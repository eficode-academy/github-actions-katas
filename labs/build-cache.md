# Reusing build cache 

GitHub Actions has a few different methods for reusing files and artifacts produced in a job, in downstream jobs or even in subsequent builds.

This is needed because each job in GitHub Actions is running in a separate Docker container or machine, and by default no files are shared between these.

# Caching 

The caching mechanism is persistent across multiple builds, and therefore a key is needed.

One example is to store downloaded dependencies in a cache, to avoid downloading the same dependencies over and over. And since dependencies typically are defined in one central file, this file is hashed and used as a key. At GitHub Actions `actions/cache@v3` can be used to do it. Possible input parameters are:
* `path` - (required) The file path on the runner to cache or restore. The path can be an absolute path or relative to the working directory.
* `key` - (required) The key created when cache was saved and later used to find it. 
* `restore-keys` - (optional) An ordered list of alternative keys to use for finding the cache if no cache hit occurred for key.

The example for gradle can be seen below.

``` yaml
- name: Cache Gradle packages
  uses: actions/cache@v3
  with:
    path: |
      ~/.gradle/caches
      ~/.gradle/wrapper
    key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
    restore-keys: |
      ${{ runner.os }}-gradle-
```

To use cache at the consecutive jobs, the same code (from above example) has to be added as a step to each job.

Limitations on using caching:
* GitHub will delete all unaccessed caches after 7 days.
* There is no limit on how many caches can be stored, however if the total space used by the repository exceeds 10GB GitHub will start deleting the oldest caches.

## Recap: Caching vs. Artifacts
`actions/cache`: Its purpose is to speed up future workflow runs by saving and reusing files that don't change often, like third-party dependencies (~/.gradle/caches). It is not designed to pass files between jobs in the same run.

`actions/upload-artifact`: Its purpose is to pass files between jobs within the same workflow run. This is the correct, reliable, and intended way to share your build output from the build job with the test job.

# Tasks 

In this exercise we will implement caching as follows: 

1. Create a new GitHub Actions file under `./github/workflows/caching.yaml` with exact copy of the pipeline from [exercise 7](../trainer/.github/workflows/caching.yaml) .

Your `build` and `test` jobs use Gradle. You can cache the Gradle dependencies that are downloaded during the build process. This is the most significant opportunity for improvement in your workflow. By caching these, subsequent runs will be much faster unless your dependencies change.

For caching Docker layers in the `publish` job, instead of running custom scripts, it's better to use the `docker/build-push-action`. This action has built-in support for caching Docker layers directly to the GitHub Actions cache, which is much more efficient than re-building every layer on every run.

2. Use caching with an above example for Gradle.
3. Should artifacts be uploaded at the end of the workflow?

If you need to see the whole workflow, expand the section below.

Also, if you are using multiple workflows, a good idea to change their triggers to `on: workflow_dispatch` to avoid running all workflows on every commit.

<details>
    <summary> Solution </summary>
  
```YAML
name: Caching workflow

on: push

env:
  docker_username: ${{ github.actor }}
  docker_password: ${{ secrets.GITHUB_TOKEN }}
  GIT_COMMIT: ${{ github.sha }}
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  lint:
    name: "Lint Code"
    runs-on: ubuntu-latest
    steps:
      - name: "Clone repository"
        uses: actions/checkout@v4
      - name: "Run linter"
        uses: super-linter/super-linter/slim@v7
        env:
          DEFAULT_BRANCH: main
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          DISABLE_ERRORS: true

  build:
    name: "Build Application"
    runs-on: ubuntu-latest
    container: gradle:6-jdk11
    steps:
      - name: "Clone repository"
        uses: actions/checkout@v4

      - name: "Cache Gradle packages"
        uses: actions/cache@v4
        with:
          path: |
            ~/.gradle/caches
            ~/.gradle/wrapper
          key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
          restore-keys: |
            ${{ runner.os }}-gradle-

      - name: "Grant execute permission"
        run: chmod +x ./ci/build-app.sh
      - name: "Build application"
        run: ./ci/build-app.sh

      - name: "Upload build artifact"
        uses: actions/upload-artifact@v4
        with:
          name: code
          path: .

  test:
    name: "Run Unit Tests"
    runs-on: ubuntu-latest
    needs: build
    container: gradle:6-jdk11
    steps:
      - name: "Clone repository"
        uses: actions/checkout@v4

      - name: "Cache Gradle packages"
        uses: actions/cache@v4
        with:
          path: |
            ~/.gradle/caches
            ~/.gradle/wrapper
          key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
          restore-keys: |
            ${{ runner.os }}-gradle-

      - name: "Download build artifact"
        uses: actions/download-artifact@v4
        with:
          name: code
          path: .

      - name: "Grant execute permission"
        run: chmod +x ./ci/unit-test-app.sh
      - name: "Run tests"
        run: ./ci/unit-test-app.sh

  publish:
    name: "Build and Push Docker Image"
    runs-on: ubuntu-latest
    needs: [test, lint]
    permissions:
      contents: read
      packages: write
    steps:
      - name: "Clone repository"
        uses: actions/checkout@v4

      - name: "Download build artifact"
        uses: actions/download-artifact@v4
        with:
          name: code
          path: .

      - name: "Log in to GitHub Container Registry"
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: "Set up Docker Buildx"
        uses: docker/setup-buildx-action@v3

      - name: "Build and push Docker image"
        uses: docker/build-push-action@v6
        with:
          context: ./app
          push: true
          tags: |
            ${{ env.REGISTRY }}/${{ github.actor }}/micronaut-app:latest
            ${{ env.REGISTRY }}/${{ github.actor }}/micronaut-app:1.0-${{ env.GIT_COMMIT }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  component-test:
    runs-on: ubuntu-latest
    needs: publish
    steps:
      - name: "Clone repository"
        uses: actions/checkout@v4

      - name: "Make script executable"
        run: chmod +x ci/component-test.sh
      - name: "Execute component test"
        run: ./ci/component-test.sh

  performance-test:
    runs-on: ubuntu-latest
    needs: publish
    steps:
      - name: "Clone repository"
        uses: actions/checkout@v4

      - name: "Make script executable"
        run: chmod +x ci/performance-test.sh
      - name: "Execute performance test"
        run: ./ci/performance-test.sh
```

</details>

## Resources 
More information about caching can be found here: https://docs.github.com/en/actions/guides/caching-dependencies-to-speed-up-workflows

Cache action tool: https://github.com/actions/cache
