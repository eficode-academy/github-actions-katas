# Building the application

Github Actions is configured through the [YAML files](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions).

:bulb: The trickiest part of writing the configuration files is typically getting the indentation right.

## learning goals

- Understand the basic structure of a workflow file
- Understand the basic structure of a job
- Understand the basic structure of a step

## Building a CI pipeline in GitHub Actions

In this workshop we will use a small Java web service which is built and tested using Gradle.

The details of the implementation are not relevant for the purposes of these exercises. We will
instead focus on how to build a CI pipeline using GitHub Actions, that builds, tests and packages
the webservice.

The application is found in the `app` directory. Scripts to build, test and package the web service
are found in the `ci` directory.

We ultimately want a pipeline that has the following jobs:

- **Build and test:** Clones down and run the gradle build command found in [ci/build-app.sh](../ci/build-app.sh), and thereafter runs the gradle test command found in [ci/unit-test-app.sh](../ci/unit-test-app.sh)
- **Build docker:** runs both [building of the docker image](../ci/build-docker.sh), and [pushes it up to the hub](../ci/push-docker.sh)
- **Component test:** runs a [docker-compose file](../component-test/docker-compose.yml) with a [python test](../component-test/test_app.py) to test the application.
- **Performance test:** runs a [docker-compose file](../performance-test/docker-compose.yml) with a [k6 performance tester](../performance-test/single-request.js) to test the application.

We are not going to do it all in one go, but rather step by step.

### A basic example

Examine the following example workflow definition:

```yaml
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
```

A line-by-line explanation of the above:

- **Line 1**: Specifies the name of the workflow, in this case, "Main workflow".
- **Line 2**: Specifies that the workflow should be triggered on a `push` event.
- **Line 3**: Introduces the `jobs` section where all job definitions reside.
- **Line 4-5**: Defines a job named `Build` that runs on an Ubuntu VM.
- **Line 6**: Specifies that the job should run in a container with the image `gradle:6-jdk11`.
- **Line 7**: Defines the steps that should be executed in the job.
- **Line 8**: Defines a step named `Clone down repository` ...
- **Line 9**: ... which uses the action `actions/checkout@v4`, to clone down the repository's content
  to the runner, enabling subsequent steps to access it.
- **Line 10**: Defines a step named `Build application` ...
- **Line 11**: ... which runs the `build-app.sh` script found in the `ci` directory of the repository.

This workflow is a basic example that provides insights into the event type, branch reference, and repository structure when code is pushed to it.

If you want to see what `build-app.sh` is doing, look into [the script](../ci/build-app.sh).

## Task

- Replace the contents of `.github/workflows/main.yml` with the above example.
- Add and commit the file and push it to GitHub.

<details>
<summary>:bulb: Git commands to do it if you are using the terminal</summary>

```bash
git add .github/workflows/main.yml
git commit -m "Add basic workflow to build the web service"
git push

```

</details>

- Go to Github Actions tab of the repository and check the action status.
- When the build is green, click the `Build` job entry to see the workflow log.
- Expand the `Build application` step to see the output of the build.

### Results

See that the build status is green and the job log looks something like this:

```bash
Run ./ci/build-app.sh
Starting a Gradle Daemon (subsequent builds will be faster)
> Task :clean UP-TO-DATE

> Task :compileJava
Note: Creating bean classes for 3 type elements

> Task :processResources
> Task :classes
> Task :shadowJar

Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/6.9.4/userguide/command_line_interface.html#sec:command_line_warnings

BUILD SUCCESSFUL in 15s
4 actionable tasks: 3 executed, 1 up-to-date
```

## Summary

Congratulations, you have now built the Java web service!

But we have some way to go yet, we want to build a Docker image, and run some tests on it as well.
