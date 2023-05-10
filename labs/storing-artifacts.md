## Storing artifacts

When running multiple jobs, the VM you get for each job is completely new. 

This means that the state of the repository is not persisted between jobs.

It is possible to store your state (and therfore also artifacts) in Github Actions. 

An `artifact` could be the result of the build, in this case the compiled code.

> This should not be mistaken for proper [artifact management](https://www.eficode.com/blog/artifactory-nexus-proget), or [release management](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) but it is useful for making the artifacts built by the pipeline available.

To deal with artifacts, a `Github Actions Action` can be used, which can be found on [Github Marketplace](https://github.com/marketplace).

To upload artifacts use the following syntax with `actions/upload-artifact@v3` [Link to documentation](https://github.com/marketplace/actions/upload-a-build-artifact):

```YAML
- name: Upload a Build Artifact
  uses: actions/upload-artifact@v3
  with:
    name: my-artifact
    path: path/to/artifact/
```

As artifacts can be uploaded it can also be downloaded from Github Actions with help of `actions/download-artifact@v3` as:

```YAML
- name: Download a single artifact
  uses: actions/download-artifact@v3
  with:
    name: my-artifact
    path: path/to/download/artifact/
```

[Link to documentation](https://github.com/actions/download-artifact)

This information will be needed in next exercises.

:bulb: 
<details>
    <summary> More information about storing artifacts </summary>
  Github has an excelent guide on how you can use persistant storage over periods of builds here: https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts
</details>    

## Exercise

### Overview

We want to add a step that makes the repository including the compiled code available for other steps to use.

In order to achieve this we will simply save the state of the entire repository after running the build script.

### Tasks

- Add step named `Upload Repo` to the existing job, which will upload an artifact with the name `code`, with the path `.` to use the current directory.

```YAML
    - name: Upload Repo
      uses: actions/upload-artifact@v3
      with: 
        name: code
        path: .
```


### Solution
If you strugle and need to see the whole ***Solution*** you can extend the section below. 
<details>
    <summary> Solution </summary>
  
```YAML
on: push
jobs:
  Build:
    runs-on: ubuntu-latest
    container: gradle:6-jdk11
    steps:
      - name: Clone-down
        uses: actions/checkout@v3       
      - name: Build application
        run: chmod +x ci/build-app.sh && ci/build-app.sh
      - name: Test
        run: chmod +x ci/unit-test-app.sh && ci/unit-test-app.sh
      - name: Upload Repo
        uses: actions/upload-artifact@v3
        with: 
          name: code
          path: .
```
  
</details>

## Results 

If all works out fine, your newest build should show something like, where you can find your uploaded artifact:
![Uploading artifact](img/storing-artifact.png)

### Resources

https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts
