# Build app on multiple environments

Github actions provides a method to run your tests with various input. This can
be useful if you want to make sure that the code builds on different versions of,
e.g., Java or Node. To avoid repeating the same thing in `YAML`, you can use
[`strategy`](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstrategy)

The app in this repository is Java-based and it is running on Java 11. The example how we can use it for different versions of Node:
```yaml 
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [8, 10, 12]
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
```
With this, the job will run three seperate jobs for different versions of NodeJS; 8, 10 and 12. 
There can be similar solution for container based pipelines: 

```YAML
name: matrix-example
on: [workflow_dispatch]

jobs:
  job:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        container: ["ubuntu:bionic", "fedora:31", "opensuse/leap:42.3", "centos:8"]
    container:
      image: ${{ matrix.container }}      
    steps:
      - name: check os
        run: cat /etc/os-release
```
In this example pipeline runs-on `ubuntu-latest` for 4 different containers: `"ubuntu:bionic", "fedora:31", "opensuse/leap:42.3", "centos8"`. This way we can skip repeating the workflows.


## Tasks
we would like to build our application on different versios of Java. 

### Add a new job that builds on various versions

- You can add a new file on `.github/workflows/matrix.yml`, which will only include `Clone-down`and `Build` job. 

<details>
<summary> Build job </summary>

```YAML
name: Matrix workflow
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
  ```

</details>

____


- Edit build job to run  for different versions of Java. Add matrix for types of containers as: `["gradle:6-jdk8", "gradle:6-jdk11", "gradle:6-jdk17"]` to your build job. 

```yaml

strategy:
  matrix:
    container: ["gradle:6-jdk8", "gradle:6-jdk11", "gradle:6-jdk17"]

```


_____
- Remember to edit container name:

```yaml
    container:
      image: ${{ matrix.container }}     
```

<details>
<summary> Solution</summary>

``` yaml  
name: Matrix workflow
on: push
jobs:
  Build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        container: ["gradle:6-jdk8", "gradle:6-jdk11", "gradle:6-jdk17"]
    container:
      image: ${{ matrix.container }}   

    steps:
      - name: Clone down repository
        uses: actions/checkout@v4       
      - name: Build application
        run: ci/build-app.sh
      - name: Test
        run: ci/unit-test-app.sh
```
</details>

## Results 
You should have 3 jobs under `Build` job for different version of Java. 

### Questions:

* Are there versions of Java which do not work?
