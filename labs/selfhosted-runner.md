# Local runners

Github actions provides a lot of minutes you can run your pipeline on their machines.
But it can be that you want to run your pipeline locally as well.

There are especially two reasons for this:

* You want faster hardware to run your pipeline, shortening the feedback loop of the development process.
* You have hardware requirements that needs to be met (special network card, USB peripheral, etc.).

You still reap the benefits of a central CI/CD controller, but have the possibility to run locally.

We want to take parts of your pipeline and run it locally, to see if that will speed up the process.

## Tasks

You will be running a selfhosted runner on your local machine or on a VM if you have
one available. To verify that the runner works, you will set up and run a workflow that
matches to OS of your local machine.

### Setup a workflow to test with

The first step is to set up and test the workflow that you intend to run locally.
There are separate, prepared workflow files available depending on the OS you
har on your local machine.

1. Copy one of the following files to your `.github/workflows` folder:

   * Windows: `labs/selfhosted-runners/hello-world-windows.yml`
   * MacOS or Linux: `labs/selfhosted-runners/hello-world-unix.yml`
  
   The workflows are initially set up to run on appropriate Windows or Linux runners
   hosted by GitHub.

2. Commit and push the changes, so that the workflow is available in the GitHub UI.
3. Go the the Actions tab in the GitHub UI and run the `Hello Selfhosted Runner` workflow.
4. Verify that the workflow has run successfully and examine the output.

### Setup a local runner

Now that you have a workflow to test with, you need to deploy an instance of the GitHub Runner
application on your local machine and configure it to connect to your GitHub account.

1. In the `github-actions-katas` repository on your personal GitHub account, click on Settings > Actions > Runners
2. Click the `"New self-hosted runner"` button in the upper right-hand corner.
3. Choose an OS and Architecture that matches your local machine
   * On Windows and Linux, the achitecuter will likely be `x64`
   * On MacOS, the architecture will likely be `ARM64`
4. Follow the download instructions and configure instructions in a new terminal window.

The instructions will guide you to

1. create a folder for the local runner
2. download and extract the necessary binary
3. configure it to access your repository using a token generated as part of the instructions.
   Press enter in each step of the configuration wizard to choose the default options.
4. run the local runner instance

You should see something like this at the end:

```bash
$  ./run.sh

√ Connected to GitHub

Current runner version: '2.329.0'
2025-11-04 21:17:44Z: Listening for Jobs
```

Now you are ready to use the runner in your workflow.

### Run a workflow against the local runner

To verify that workflows run on your local runner, we need to update the test workflow
and run it again. We will observe that the log in your local terminal will print
status messages from the workflow.

1. Edit the `Hello Selfhosted Runner` workflow file in `.github/workflows`
2. Change the `runs-on` parameter in the component test from `ubuntu-latest` or
   `windows-latest` to `self-hosted`

   ```yaml
     hello-world:
       runs-on: [self-hosted]
   ```

3. Commit and push the change, then trigger the workflow manually.
4. In the terminal where you are running the GitHub Actions runner, you should see something like this:

   ```bash
   2025-11-04 21:18:41Z: Running job: hello-world
   2025-11-04 21:18:51Z: Job hello-world completed with result: Succeeded
   ```

### Removing the local runner

Since this is just a test, and you don't want local runners available in public repositories,
you need to remove the runner registration from GitHub and clean up the working directory

1. In the `github-actions-katas` repository on your personal GitHub account, click on Settings > Actions > Runners
2. Click on your newly created runner to open its status page. Here you can see any
   currently active jobs on the runner.
3. Press the big red Remove button. The dialog that appears will show you the necessary
   command to de-register the runner.
4. Copy the command to remove the runner.
5. Switch to the terminal window where the local runner is active.
6. Press `Crtl+C` to stop the runner.
7. Paste the `remove` command into the shell and execute it.
   * Observe that the runner is now removed from the GitHub UI.
8. Finally delete the folder that you created for the runner. This will clean up
   any work files and binaries that we have downloaded.

Congratulations! You have now configured a local runner, used it in your workflow
and cleaned it up again!

### Resources

[Adding self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners)
