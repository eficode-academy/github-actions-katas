# Katas

This workshop is not about making the nitty gritty details of how to build, but making you comfortable with Github Actions terminology.

Therefore we have made a small application with all the ci scripts around it to build,test,and package the application, all stored under the `ci` folder.

We ultimately want a pipeline that has the following jobs:

## Setup

You need to have your own fork of this workshop repository in order for the exercises to work.

### Tasks

Setting up your repository is fairly simple;

* Fork this repository from the Github website into your own account, and then git clone the project from your own fork down to your computer.
* Leave the browser open and go back to the repository on your computer.
* Create a folder named .github and then workflows and add a file called config.yml (so that the file path will be .github/workflows/hello-world.yml relative to the root of the repository). In the terminal you can do it like this:

```bash
mkdir .github
cd .github
mkdir workflows 
touch .github/workflows/hello-world.yml
```

Now we have set up the fundamentals to run a basic `hello world` build in Github Actions. However, running it would make Github Actions complain, as there is nothing in the file.


## Table of content

The list here is the natural progression of the labs, but they are made so that they can be worked on independently.

* [Making "hello world"](01-hello-world-pipeline.md)
* [Pipeline with Dockerfile](02-pipeline-with-dockerfile.md)
* [Extending pipeline](03-extend-pipeline.md)
* [Storing artifacts](04-storing-artifacts.md)
* [Workflow](05-workflow.md)
* [Dockerimage](06-docker-image.md)
* [Component test](07-component-test.md)