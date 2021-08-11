## Storing artifacts 
It is possible to store artifacts in Github Actions. Artifact is the results of the jobs. It may consist of the project source code, dependencies, binaries or resources, and could be represented in different layout depending on the technology.

> This is not to be mistaken for artifact management, but it is a nice way to make files available in the Github Actions web interface.

To upload artifacts use the following syntax:

```YAML
- name: Upload a Build Artifact
  uses: actions/upload-artifact@v2
  with: 
    name: my-artifact
    path: path/to/artifact/
```

As artifacts can be uploaded they can also be downloaded from Github Actions as: 

```YAML
- name: Download a single artifact
  uses: actions/download-artifact@v2
  with:
    name: my-artifact
    path: path/to/download/artifact/
```
This information will be needed in next exercises. 

More information about storing artifacts: https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts

### Tasks 

1. Add step named `Upload Repo` to the existed job, which will upload artifact called `code` from current directory. 

If all works out fine, your newest build should show something like:
![Uploading artifact](img/storing-artifact.png)