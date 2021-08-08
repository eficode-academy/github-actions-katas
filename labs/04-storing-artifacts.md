## Storing artifacts 
It is possible to store artifacts in Github Actions

> This is not to be mistaken for artifact management, but it is a nice way to make files available in the Github Actions web interface.

To store artifacts use the following syntax:

```
- name: Upload a Build Artifact
  uses: actions/upload-artifact@v2
  with: 
    name: my-artifact
    path:  path/to/artifact/

```

More information: https://docs.github.com/en/actions/guides/storing-workflow-data-as-artifacts

### Tasks 

> Hint: The results of running `ci/build-app.sh` are actually stored in a local directory: `app/build/libs`

If all works out fine, your newest build should show something like:
