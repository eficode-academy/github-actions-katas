## Storing artifacts

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
      - name: Upload Repo
        uses: actions/upload-artifact@v4
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
