# Github Actions Katas

This series of katas will go through the basic steps in github actions, making you able to make CI builds in the end.

## Learning Goals

- Forking the repository
- Creating a workflow file

## Building a CI pipeline in GitHub Actions

In this workshop we will be using a small java service which uses Gradle to build the application.

The application is found in the `app` directory, though the details of the implementation are not interesting for the purposes of these katas.
There are a number of shell scripts that help with building the application, these are located in the `ci` directory.

The purpose of these katas is to use the small java application to exemplify how to use Github Actions to build, test and package your applications.

We ultimately want a pipeline that has the following jobs:

- **Clone down:** makes the git clone, and prepares the repo for being distributed to the parallel steps
- **Test:** runs the gradle test command found in [ci/unit-test-app.sh](../ci/unit-test-app.sh)
- **Build:** runs the gradle build command found in [ci/build-app.sh](../ci/build-app.sh)
- **Build docker:** runs both [building of the docker image](../ci/build-docker.sh), and [pushes it up to the hub](../ci/push-docker.sh)
- **Component test:** runs a [docker-compose file](../component-test/docker-compose.yml) with a [python test](../component-test/test_app.py) to test the application.
- **Performance test:** runs a [docker-compose file](../performance-test/docker-compose.yml) with a [k6 performance tester](../performance-test/single-request.js) to test the application.

We are not going to do it all in one go, but rather step by step.
## Exercise

### Overview

In this exercise we are forking a repository, and creating a workflow file called `.github/workflows/hello-world.yml`.

<details>
<summary>:bulb: This requires git email and name to bee configured on your machine. If you have not done this, here are the commands to set it up</summary>

You need to provide your email and name to git with the following commands.

``` bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

</details>

### Tasks

- Fork this repository from the Github website into your own account.

> :bulb: **From now on _only_ use the forked repository.**

- From your fork, clone down that repository to your machine.
- In your newly cloned down repository, make a folder called `.github` and inside that one, another folder called `workflows`.

<details>
<summary>:bulb: terminal commands to do it</summary>

```bash
mkdir .github
cd .github
mkdir workflows
```

</details>

- inside that folder, add a file called hello-world.yml (The file path will be `.github/workflows/hello-world.yml` relative to the root of the repository).

<details>
<summary>:bulb: terminal commands to do it</summary>

```bash
touch .github/workflows/hello-world.yml
```

</details>

- Push your changes to github, and navigate to the repository to check that the file has been created.

<details>
<summary>:bulb: Git commands to do it</summary>

```bash
git add .github/workflows/hello-world.yml
git commit -m "Add hello world workflow"
git push

```

</details>

Now we have set up the fundamentals to run a basic `hello world` build in Github Actions. However, running it would result in an error, as there is nothing in the file.

So in the next section we will be creating the simplest possible workflow.

