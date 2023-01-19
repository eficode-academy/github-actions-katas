## Systems test

After having our releaseable component (our docker file), we can now run our system tests to promote the artifact.

In the repository we have made two different system tests; component test and performance test.

Both requires your docker username and password as env, and a `ci/component-test.sh` script that runs a docker-compose file with component tests.

## Tasks

- Add job named `Component-test`, which will run `ci/component-test.sh` script that runs a docker-compose file with component tests.

```YAML
- name: Execute component test
  run: chmod +x ci/component-test.sh && GIT_COMMIT="GA-$GITHUB_SHA" && ci/component-test.sh
```

- This job needs to be dependent on `Docker-image` job.

- Add another job named `Performance-test`, which will run `ci/performance-test.sh` script that runs a docker-compose file with performance tests. (Same YAML structure as above)
- It too needs to be dependent on `Docker-image` job.


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
      uses: actions/download-artifact@v3
      with:
        name: code
        path: .
    - name: Execute component test
      run: chmod +x ci/component-test.sh && ci/component-test.sh
  Performance-test:
    runs-on: ubuntu-latest
    needs: Docker-image
    steps:
    - name: Download code
      uses: actions/download-artifact@v3
      with:
        name: code
        path: .
    - name: Execute performance test
      run: chmod +x ci/performance-test.sh && ci/performance-test.sh
```
  
</details>

