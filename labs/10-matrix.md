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
        node: [6, 8, 10]
    steps:
      - uses: actions/setup-node@v2
        with:
          node-version: ${{ matrix.node }}
```
Here, job will run three seperate jobs for different versions of Node 6, 8 and 10. 
There can be similar solution for container based pipelines: 

```YAML
jobs:
  job:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        container: ["ubuntu:bionic", "fedora:31", "opensuse/leap:42.3", "centos8"]
    container:
      image: ${{ matrix.container }}      
     steps:
      - name: checkout
        uses: actions/checkout@v1
```
In this example pipeline runs-on `ubuntu-latest` for 4 different containers: `"ubuntu:bionic", "fedora:31", "opensuse/leap:42.3", "centos8"`. This way we can skip repeating the workflows.


## Tasks
we would like to test our component test on different versios of Java. 

### Add a new job that builds on various versions

- You can add a new file on `.github/workflows/` similar to the `component-test.yml`.

___

- Edit component test job to run  for different versions of Java. Add matrix for types of containers as: `["6-jdk8", "6-jdk11", "6-jdk17"]`. 


___
- Remember to edit container name:

```yaml
    container:
      image: ${{ matrix.container }}     
```

<details>
<summary> Solution</summary>

``` yaml  

```
</details>

#### Questions:

* Are there versions of Java which do not work?
