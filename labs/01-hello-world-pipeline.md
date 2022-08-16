## Making "hello world"

Github Actions is configured through the [YAML files](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions).

:bulb: The trickiest part of writing the configuration files is typically getting the indentation right.

### A basic example:

In order for us to make the first `hello world` pipeline, examine the following example, that makes the agent running the pipeline echo out "hello world":


```yaml
name: hello-world
on: push
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - name: my-step
        run: echo "Hello World!"
```

A line-by-line explanation of the above:

- Line 1: The `name` attribute provides useful organizational information when returning warnings, errors, and output. The name should be meaningful to you as an action within your build process.
- Line 2: The `on` is the name of the GitHub event that triggers the workflow.
- Line 3: The `jobs` level contains a collection of jobs that make up the workflow.
- Line 4-5: The `my-job` is an example of the name for a job, `runs-on` describes on which operating system the pipeline should run.
- Line 6-8: The `steps` collection is an ordered list of `run` directives. Each `run` directive is executed in the order in which it is declared.

## Task

- Paste the example into `.github/workflows/hello-world.yaml`.
- Add and commit the file and push it to Github. 
- Go to Github Actions tab of the repository and check the action status.

## Results

You should see something like this in the logs of Github Actions: (Note: The logs can be a bit hard to find the first time :-), but give it a shot)

```bash
#!/bin/sh -eo pipefail
echo 'Hello World!'

Hello World!
```
Congratulations! You have successfully created the first Github Actions workflow, and ran it successfully :tada:.