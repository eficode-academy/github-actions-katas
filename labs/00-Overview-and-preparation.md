# Github Actions Katas

This series of katas will go through the basic steps in github actions, making you able to make CI builds in the end.

Look into the labs folder for exercises.

## Building a CI pipeline in GitHub Actions

In this workshop we will be using a small java service which uses Gradle to build the application.

The application is found in the `app` directory, though the details of the implementation are not interesting for the purposes of this katas.
There are a number of shell scripts that help with building the application, these are located in the `ci` directory.

The purpose of this katas is to use the small java application to exemplify how to use Github Actions to build, test and package your applications.

We ultimately want a pipeline that has the following jobs:

- **Clone down:** makes the git clone, and prepares the repo for being distributed to the parallel steps
- **Test:** runs the gradle test command found in [ci/unit-test-app.sh](ci/unit-test-app.sh)
- **Build:** runs the gradle build command found in [ci/build-app.sh](ci/build-app.sh)
- **Build docker:** runs both [building of the docker image](ci/build-docker.sh), and [pushes it up to the hub](ci/push-docker.sh)
- **Component test:** runs a [docker-compose file](component-test/docker-compose.yml) with a [python test](component-test/test_app.py) to test the application.

## Setup

You need to have your own fork of this workshop repository in order for the exercises to work.

### Tasks

Setting up your repository is fairly simple;

- Fork this repository from the Github website into your own account, and then git clone the project from your own fork down to your VM instance, which is provided to you .
- Leave the browser open and go back to the repository on your computer.
- Create a folder named `.github` under `github-actions-katas` and then workflows and add a file called hello-world.yml (so that the file path will be .github/workflows/hello-world.yml relative to the root of the repository). In the terminal you can do it like this:

```bash
mkdir .github
cd .github
mkdir workflows
touch .github/workflows/hello-world.yml
```
- Set up git on your vm machine 
``` bash 
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

Now we have set up the fundamentals to run a basic `hello world` build in Github Actions. However, running it would result in an error, as there is nothing in the file.

So in the next section we will be creating the simplest possible workflow.

## Table of content

The list here is the natural progression of the labs, but they are made so that they can be worked on independently.

- [Making "hello world"](01-hello-world-pipeline.md)
- [Pipeline with Dockerfile](02-pipeline-with-dockerfile.md)
- [Extending pipeline](03-extend-pipeline.md)
- [Storing artifacts](04-storing-artifacts.md)
- [Workflow](05-workflow.md)
- [Dockerimage](06-docker-image.md)
- [Component test](07-component-test.md)
- [Self hosted runner](08-selfhosted-runner.md)
- [PR workflow](09-pr-workflow.md)
- [Matrix](10-matrix.md)
- [Extras](XX-extras.md)
