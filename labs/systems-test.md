# Systems test

After having our releasable component (our docker image), we can now run our system tests to promote the artifact.

In the repository we have made two different system tests; component test and performance test.

Both require your registry username and password as `env` variables in order to work. The workflow already has `github_username` and `github_password` environment variables defined for this purpose.

## Tasks

- Add job named `Component-test`
- Add a step to run `bash ci/component-test.sh` script.
  This will run a docker-compose file with component tests.

```YAML
- name: Execute component test
  run: bash ci/component-test.sh
```

- Ensure that the job is dependent on the `Docker-image` job.

- Add another job named `Performance-test`
- Add a step to run the `bash ci/performance-test.sh` script.
  This will run a docker-compose file with performance tests. (Same YAML structure as above)
- It too needs to be dependent on `Docker-image` job.

- Push the changes to GitHub and see that the tests are running.

- Congratulations! You have now made a pipeline that builds, tests and releases your application!

### Solution

If you struggle and need to see the whole ***Solution*** you can extend the section below.

<details>
    <summary> Solution </summary>
  
```YAML
  Component-test:
    runs-on: ubuntu-latest
    needs: Docker-image
    steps:
    - name: Download code
      uses: actions/download-artifact@v4
      with:
        name: code
        path: .
    - name: Execute component test
      run: bash ci/component-test.sh
  Performance-test:
    runs-on: ubuntu-latest
    needs: Docker-image
    steps:
    - name: Download code
      uses: actions/download-artifact@v4
      with:
        name: code
        path: .
    - name: Execute performance test
      run: bash ci/performance-test.sh
```
  
</details>
