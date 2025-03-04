## Systems test

After having our releaseable component (our docker image), we can now run our system tests to promote the artifact.

In the repository we have made two different system tests; component test and performance test.

Both requires your docker username as envs in order to work.

## Tasks

- Add job named `Component-test`, which will run `bash ci/component-test.sh` script that runs a docker-compose file with component tests.

```YAML
- name: Execute component test
  run: bash ci/component-test.sh
```

- This job needs to be dependent on `Docker-image` job.

- Add another job named `Performance-test`, which will run `bash ci/performance-test.sh` script that runs a docker-compose file with performance tests. (Same YAML structure as above)
- It too needs to be dependent on `Docker-image` job.

- Push the changes to GitHub and see that the tests are running.

- Congratulations! You have now made a pipeline that builds, tests and releases your application!

### Solution

If you strugle and need to see the whole ***Solution*** you can extend the section below. 

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

