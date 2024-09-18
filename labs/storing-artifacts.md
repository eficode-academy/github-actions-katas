# Storing artifacts

## Learning goal

- Create multiple jobs
- Use the Upload and download artifact action
- Use Superlinter to lint your sourcecode

### Super linter

Super-linter is a tool that can be used to lint your sourcecode. It is a combination of multiple linters, and can be used to lint multiple languages.

It's invoked as a github action, and can be found on [Github Marketplace](https://github.com/super-linter/super-linter).

In this exercise we will use it to lint our sourcecode in a separate job.

### Upload and download artifacts

When running multiple jobs, the runner you get for each job is completely new. 

This means that the state of the repository is not persisted between jobs.

> :bulb: This should not be mistaken for proper [artifact management](https://www.eficode.com/blog/artifactory-nexus-proget), or [release management](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) but it is useful for making the artifacts built by the pipeline available.

To deal with artifacts, a `Github Actions Action` can be used, which can be found on [Github Marketplace](https://github.com/marketplace).

To upload artifacts use the following syntax with `actions/upload-artifact@v4` [Link to documentation](https://github.com/marketplace/actions/upload-a-build-artifact):

```YAML
- name: Upload a Build Artifact # Name of the step
  uses: actions/upload-artifact@v4 # Action to use
  with: # Parameters for the action
    name: my-artifact # Name of the artifact to upload. Optional. Default is 'artifact
    path: path/to/artifact/ # A file, directory or wildcard pattern that describes what to upload. Required.
```

As artifacts can be uploaded it can also be downloaded from Github Actions with help of `actions/download-artifact@v4` as:

```YAML
- name: Download a single artifact # Name of the step
  uses: actions/download-artifact@v4 # Action to use
  with: # Parameters for the action
    name: my-artifact # Name of the artifact to download. Optional. If unspecified, all artifacts for the run are downloaded.
    path: path/to/download/artifact/     # Destination path. Supports basic tilde expansion.  # Optional. Default is $GITHUB_WORKSPACE
```

You can find more information around the different parameters via the [link to documentation for download action](https://github.com/actions/download-artifact).

:bulb: 
<details>
    <summary> More information about storing artifacts </summary>
  Github has an excelent guide on how you can use persistant storage over periods of builds here: https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts
</details>    

## Exercise

### Overview

- Create a linter job
- Use the `actions/upload-artifact` and `actions/download-artifact`
- Use `super-linter/super-linter/slim` to lint your sourcecode

### Tasks

- Add step named `Upload repo` to the existing job, which will upload an artifact with the name `code`, with the path `.` to use the current directory.

```YAML
      - uses: actions/upload-artifact@v4
        with: 
          name: code
          path: .
```

<details>
<summary>complete solution</summary>

```YAML
name: Main workflow
on: push
jobs:
  Build:
    runs-on: ubuntu-latest
    container: gradle:6-jdk11
    steps:
      - name: Clone down repository
        uses: actions/checkout@v4       
      - name: Build application
        run: ci/build-app.sh
      - name: Test
        run: ci/unit-test-app.sh
      - name: Upload repo
        uses: actions/upload-artifact@v4
        with: 
          name: code
          path: .
```

</details>

Push that up to your repository and check the actions tab.

If all works out fine, your newest build should show something like, where you can find your uploaded artifact:
![Uploading artifact](img/storing-artifact.png)

#### Super-linter

We will now create a new job, which will use super-linter to lint our sourcecode.

- add a new job named `Linting` to your workflow
- Like the other job it will run on `ubuntu-latest`
- It `needs` the `Build` step. Add a line under `runs-on` with `needs: [Build]`
- It will have two steps, `Download code` and `run linting`
  - `Download code` uses the `actions/download-artifact@v4` action to download the artifact `code` to the current directory `.`
  - `run linting` uses the `super-linter/super-linter/slim` action to lint the code. It needs two environment variables to work:
    - `DEFAULT_BRANCH` which should be set to `main`
    - `GITHUB_TOKEN` which should be set to `${{ secrets.GITHUB_TOKEN }}`

<details>
<summary>complete solution</summary>

```YAML
  Linting:
    runs-on: ubuntu-latest
    needs: [Build]
    steps:
      - name: Download code
        uses: actions/download-artifact@v4
        with:
          name: code
          path: .
      - name: run linting
        uses: super-linter/super-linter/slim@v5 
        env:
          DEFAULT_BRANCH: main
          # To report GitHub Actions status checks
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
</details>

Push that up to your repository and check the actions tab.

Ohh no! the linting failed! What happened?

The log should show something like this:

```
2024-01-31 10:50:44 [INFO]   ----------------------------------------------
2024-01-31 10:50:44 [INFO]   ----------------------------------------------
2024-01-31 10:50:44 [INFO]   The script has completed
2024-01-31 10:50:44 [INFO]   ----------------------------------------------
2024-01-31 10:50:44 [INFO]   ----------------------------------------------
2024-01-31 10:50:44 [ERROR]   ERRORS FOUND in BASH:[3]
2024-01-31 10:50:45 [ERROR]   ERRORS FOUND in DOCKERFILE_HADOLINT:[1]
2024-01-31 10:50:45 [ERROR]   ERRORS FOUND in GITHUB_ACTIONS:[2]
2024-01-31 10:50:45 [ERROR]   ERRORS FOUND in GOOGLE_JAVA_FORMAT:[5]
2024-01-31 10:50:46 [ERROR]   ERRORS FOUND in JAVA:[5]
2024-01-31 10:50:46 [ERROR]   ERRORS FOUND in JAVASCRIPT_STANDARD:[1]
2024-01-31 10:50:46 [ERROR]   ERRORS FOUND in JSCPD:[1]
2024-01-31 10:50:47 [ERROR]   ERRORS FOUND in MARKDOWN:[12]
2024-01-31 10:50:47 [ERROR]   ERRORS FOUND in NATURAL_LANGUAGE:[9]
2024-01-31 10:50:47 [ERROR]   ERRORS FOUND in PYTHON_BLACK:[1]
2024-01-31 10:50:47 [ERROR]   ERRORS FOUND in PYTHON_FLAKE8:[1]
2024-01-31 10:50:48 [ERROR]   ERRORS FOUND in PYTHON_ISORT:[1]
2024-01-31 10:50:48 [FATAL]   Exiting with errors found!
```

It seems like we have some linting errors in our code. As this is not a python/bash/javascript course, we will not fix them, but silence the linter with another environment variable.

- Add the environment variable `DISABLE_ERRORS` to the `run linting` step, and set it to `true`

```YAML
      - name: run linting
        uses: super-linter/super-linter/slim@v5 
        env:
          DEFAULT_BRANCH: main
          # To report GitHub Actions status checks
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          DISABLE_ERRORS: true  
```

Push that up to your repository and see that the linting now passes, even though we have errors in our code.

Congratulations! You have now created a workflow with multiple jobs, and used artifacts to share data between them.

### Resources

https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts
