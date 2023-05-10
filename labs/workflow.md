## Seperate your workflow

When you have larger or more complex projects, you’ll want separate jobs to do separate things in paralell.

Up until now, we have had a job called `Build` both for the build and test, but that is not necessarily descriptive.

We define each job as a collection of `jobs` key:

```YAML
jobs:
  my_first_job:
    name: My first job
  my_second_job:
    name: My second job
```

By default all jobs are run in parallel. To control the order of jobs execution, we can add the `needs`key. 
A job can declare that it `needs` one or more (a list) of jobs to finish successfully before it is triggered.

To run the two jobs sequentially we define a workflow where job-2 "requires" job-1 to have run before it starts.

```YAML
name: workflow
jobs:
  job-1:
  job-2:
    needs: job-1
```

This also ensures that `job-2 ` is not run if `job-1 ` fails. It is possible to add a name to the workflow e.g. here: `name: workflow`.

To ensure that all files from previous jobs are available at new one, we have to make sure to upload artifact at the end of the job and download it at the beginning of a new one. The way to do it can be found in previous exercise `04-storing-artifacts.md`.

### Tasks

Let's try to clean up our current build by utilizing workflows:

- Name your workflow `Java CI`.

```YAML
name: JAVA CI
```

___

- Divide your job into two jobs: `Clone-down` and `Build`. `Clone-down` will checkout the repository, `Build` will build the code, run the tests, and stores the results.

```YAML
jobs: 
  Clone-down:
    ...
  Build:
    ...

```
___

- `Build` should be dependent on `Clone-down` job. Each of them also needs a running instance and container.

```YAML
Clone-down:
    runs-on: ubuntu-latest
    container: gradle:6-jdk11
    steps:
      - ...
```

___

- Remember that to have information from previous job(s) the artifact with this information needs to be downloaded and respectively uploaded by using (`actions/upload-artifact@v3`and `actions/download-artifact@v3`).

## Solution

If you strugle and need to see the whole ***Solution*** you can extend the section below. 
<details>
    <summary> Solution </summary>

```YAML
name: Java CI
on: push
jobs:
  Clone-down:
    name: Clone down repo
    runs-on: ubuntu-latest
    container: gradle:6-jdk11
    steps:
    - uses: actions/checkout@v3
    - name: Upload Repo
      uses: actions/upload-artifact@v3
      with:
        name: code
        path: .
  Build:
      runs-on: ubuntu-latest
      needs: Clone-down
      container: gradle:6-jdk11
      steps:
      - name: Download code
        uses: actions/download-artifact@v3
        with:
          name: code
          path: .
      - name: Build with Gradle
        run: chmod +x ci/build-app.sh && ci/build-app.sh
      - name: Test with Gradle
        run: chmod +x ci/unit-test-app.sh && ci/unit-test-app.sh
      - name: Upload Repo
        uses: actions/upload-artifact@v3
        with:
          name: code
          path: .
 ```
 </details>

## Results

Opening it should show something like:

![Screenshot workflow](img/workflow.png)

More information about this topic can be found here: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions

## Resources

https://github.com/marketplace/actions/upload-a-build-artifact
https://github.com/marketplace/actions/download-a-build-artifact
