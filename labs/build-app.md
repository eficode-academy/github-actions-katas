## Building the application

Github Actions is configured through the [YAML files](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions).

:bulb: The trickiest part of writing the configuration files is typically getting the indentation right.

### learning goals

- Understand the basic structure of a workflow file
- Understand the basic structure of a job
- Understand the basic structure of a step

## Building a CI pipeline in GitHub Actions

In this workshop we will be using a small java service which uses Gradle to build the application.

The application is found in the `app` directory, though the details of the implementation are not interesting for the purposes of these katas.
There are a number of shell scripts that help with building the application, these are located in the `ci` directory.

The purpose of these katas is to use the small java application to exemplify how to use Github Actions to build, test and package your applications.

We ultimately want a pipeline that has the following jobs:

- **Build and test:** Clones down and run the gradle build command found in [ci/build-app.sh](../ci/build-app.sh), and thereafter runs the gradle test command found in [ci/unit-test-app.sh](../ci/unit-test-app.sh)
- **Build docker:** runs both [building of the docker image](../ci/build-docker.sh), and [pushes it up to the hub](../ci/push-docker.sh)
- **Component test:** runs a [docker-compose file](../component-test/docker-compose.yml) with a [python test](../component-test/test_app.py) to test the application.
- **Performance test:** runs a [docker-compose file](../performance-test/docker-compose.yml) with a [k6 performance tester](../performance-test/single-request.js) to test the application.

We are not going to do it all in one go, but rather step by step.

### A basic example:

Now we want to diver a bit more into a pipeline.

Examine the following example, that makes the agent running the pipeline echo out "hello world":


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
      - run: ci/build-app.sh
```

A line-by-line explanation of the above:

- **Line 1**: Specifies the name of the workflow, in this case, "Main workflow".
- **Line 2**: Specifies that the workflow should be triggered on a `push` event.
- **Line 3**: Introduces the `jobs` section where all job definitions reside.
- **Line 4-5**: Defines a job named `Build` that runs on an Ubuntu VM.
- **Line 6**: Specifies that the job should run in a container with the image `gradle:6-jdk11`.
- **Line 7**: Defines the steps that should be executed in the job.
- **Line 8**: A step named `Clone down repository`
- **Line 9**: Uses the action `actions/checkout@v4`, to clone down the repository's content to the runner, enabling subsequent steps to access it.
- **Line 10**: Runs the `build-app.sh` script found in the `ci` directory of the repository.


This workflow is a basic example that provides insights into the event type, branch reference, and repository structure when code is pushed to it.

If you want to see what `build-app.sh` is doing, look into [the script](../ci/build-app.sh). 

## Task

- Replace the workflow you created in `.github/workflows/main.yml` with the above example.
- Add and commit the file and push it to Github. 

<details>
<summary>:bulb: Git commands to do it if you are using the terminal</summary>

```bash
git add .github/workflows/hello-world.yml
git commit -m "Add hello world workflow"
git push

```

</details>

- Go to Github Actions tab of the repository and check the action status.

### Results 
See that the build runs green and outputs this in the step log:

```bash
Run ./ci/build-app.sh

Welcome to Gradle 6.9!

Here are the highlights of this release:
 - This is a small backport release.
 - Java 16 can be used to compile when used with Java toolchains
 - Dynamic versions can be used within plugin declarations
 - Native support for Apple Silicon processors

For more details see https://docs.gradle.org/6.9/release-notes.html

Starting a Gradle Daemon (subsequent builds will be faster)
> Task :clean UP-TO-DATE

> Task :compileJava
Note: Creating bean classes for 3 type elements

> Task :processResources
> Task :classes
> Task :shadowJar

Deprecated Gradle features were used in this build, making it incompatible with Gradle 7.0.
Use '--warning-mode all' to show the individual deprecation warnings.
See https://docs.gradle.org/6.9/userguide/command_line_interface.html#sec:command_line_warnings

BUILD SUCCESSFUL in 28s
4 actionable tasks: 3 executed, 1 up-to-date
```

## Summary

Congratulations, you have now build the java application!

But we have some way to go yet, we want to build a docker image, and run some tests on it as well.
