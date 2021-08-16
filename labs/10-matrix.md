# Build app on multiple environments

Github actions provides a method to run your tests with various input. This can
be useful if you want to make sure that the code builds on different versions of,
e.g., Java or Node. To avoid repeating the same thing in `YAML`, you can use
[`strategy`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstrategy)

The app in this repository is Java-based.

## Tasks

### Add a new job that builds on various versions

You can add a new file on `.github/workflows/` similar to the `component-test.yml`

<details>
<summary> Hint if you get stuck</summary>

``` yaml
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        java: [8, 11, 15]
    steps:
      - name: Checkout the source code
        uses: actions/checkout@v2
      - name: Setup Java
      - uses: actions/setup-java@v2
        with:
          distribution: zulu
          java-version: ${{ matrix.java }}
      - name: Build with Gradle
        run: |
          gradle clean shadowjar -p app
```
</details>

#### Questions:

* Are there versions of Java which do not work?
