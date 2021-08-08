## Workflow

When you have larger or more complex projects, you’ll want separate jobs to do separate things (i.e. build vs. test). Despite the fact our example project is super simple, we will divide the workload to demonstrate the functionality.

Up until now, we have had a job called `build` both for the build and test, but that is not really the correct phrasing. The only reason we have done this, is because Github Actions **requires** you to have one job called `build`

So far we have only had one "job" called build even though it now has multiple steps.

It is also possible to use multiple jobs, organized in a what Github Actions calls a Workflow.

To use workflows we first have to define the jobs, i.e.:

```YAML
jobs:
  my_first_job:
    name: My first job
  my_second_job:
    name: My second job
```

However, this simple example just runs the two jobs simultaneously, which is often not what we want.

Luckily, workflows let us do things like sequential flows, fan out, fan in and so on.

To run the two job sequentially we define a workflow where job-2 "requires" job-1 to have run before it starts.

```YAML
jobs:
  job-1:
  job-2:
    needs: job-1
```
This also ensures that  `job-2 ` is not run if  `job-1 ` fails.

It is also possible to filter on branch names. This is useful to create a flow, where different branches go trough different jobs. For instance  `feature/*` branches could be tested, while the  `master  `branch is both tested and an artifact is created and stored.

```YAML
jobs:
  test_feature:
    - name: Only when feature branch is pushed
      if:   github.event_name == 'push' && github.ref == 'refs/heads/feature/*'
      uses: some/action
  test_and_build_master:
    - name: Only when master is pushed
      if:   github.event_name == 'push' && github.ref == 'refs/heads/master'
      uses: some/action
```

### Tasks
Let's try to clean up our current build by utilizing a feature called workflows.

1. Make another job in the `.github/workflows`, that is a plain copy of the first one.
2. Leave name of the first job as `Build`, divide the rest of the code to `Test` and `Upload-Artifact`
3. The `build` will build the code.
4. The `Test` job runs the tests the code, and stores the test results.
5. The `Upload artifact` will build the code, and store the artifact


Opening it should show something like:

![Screenshot workflow](img/workflow.png)

More information can be found here: https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions