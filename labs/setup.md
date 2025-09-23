# Github Actions Katas

This series of katas will go through the basic steps in github actions, making you able to make CI builds in the end.

## Learning Goals

- Creating an instance of the template repository
- Creating a workflow file seeing GitHub Actions in action

## Exercise

### Overview

In this exercise we are creating your own instance of this templated repository, and creating a workflow.

<details>
<summary>:bulb: If you want to clone the newly created repository down on your machine, you need to have git set up there. Here are the commands to set it up</summary>

You need to provide your email and name to git with the following commands.

``` bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

When you do a git clone, then you will be asked for your username and password. If you want to avoid that, you can set up an ssh key. [Here is a guide on how to do that](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).  It will take you 5-10 minutes though, so if you are in a hurry, just use the username and password.

</details>

### Tasks

#### Create a repository

- Go to _Code_ tab of this repository
- Click _Use this template_ and _Create a new repository_

  ![Use this template](../img/template.png)

- Fill in the details for your new repository:

  - Owner: Select your GitHub user as the owner.
  - Name: `github-actions-katas` or something similar.
  - Description: Add a description if you want.
  - Visibility: **Public**. This is important! Some of the exercises later on will fail if the visibility of the repository is not public.
- Press _Create repository_.
- Once the repository is created, open the _Setup_ exercise again in this new repository.

The new repository has now been created as a public repository under your own user, and you should be
reading this in the new repository.

> :bulb: **From this point forward, all actions should be performed in the repository you just created, not the template repository**

#### Create a simple workflow

In this part of the exercise we will create a simple workflow that just prints "Hello, world!" to
the build log.

- Click on the _Actions_ tab
- Click on the _Setup the workflow yourself_ link

![hello-world](../img/hello-world.png)

The file `.github/workflows/main.yml` will be opened as an empty file in the GitHub web editor.

- Copy the following content into the file and save it:

``` yaml
# This is a basic workflow to help you get started with Actions

name: CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the "main" branch
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v4

      # Runs a single command using the runners shell
      - name: Run a one-line script
        run: echo Hello, world!

      # Runs a set of commands using the runners shell
      - name: Run a multi-line script
        run: |
          echo Add other actions to build,
          echo test, and deploy your project.
```

- Click _Commit changes_ - found in the _upper right corner_ of the screen - and commit to the
  `main` branch
- Go to the _Actions_ tab and see the workflow running
- Click on the workflow and see the output of the workflow

## Summary

Congratulations! You have now created your first workflow!
It does not do much, but in the next exercise we will start building on it.
