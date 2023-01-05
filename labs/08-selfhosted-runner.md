## Local runners

Github actions provides a lot of minutes you can run your pipeline on their machines.
But it can be that you want to run your pipeline locally as well.

There are especially two reasons for this:

* You want faster hardware to run your pipeline, shortening the feedback loop of the development process.
* You have hardware requirements that needs to be met (special network card, USB peripheral, etc.).

You still reap the benefits of a central CI/CD controller, but have the possibility to run locally.

We want to take parts of your pipeline and run it locally, to see if that will speed up the process.
        
## Tasks

- Setup a local runner

    - Click on Settings > Actions > General > Runners
    - Click `"New self-hosted runner"`
    - Choose `Linux`, leave Architecture settings for `x64`
    - Follow the download instructions and configure instructions in a terminal where you are standing in `/home/ubuntu` (so not in the github-actions-katas folder) on your instance 

You should see something like this at the end:

```bash
[ubuntu@devopsacademy-instance1 actions-runner ]
$  ./run.sh

√ Connected to GitHub
```

Now you are ready to use the runner in your pipeline.

___

- Use the local runner in your pipeline

     - in your pipeline, change the `runs-on` parameter in the component test from `ubuntu-latest` to `self-hosted`

        from:

        ``` yaml
          Component-test:
            runs-on: [ubuntu-latest]
        ```

        to

        ``` yaml
          Component-test:
            runs-on: [self-hosted]
        ```

     - Commit and push that change and observe that the CI gets triggered.
     - In the terminal where you are running the GH Actions runner, you should see something like this:

        ``` bash
        2021-08-11 10:14:27Z: Listening for Jobs
        2021-08-11 10:26:17Z: Running job: Component-test
        2021-08-11 10:27:40Z: Job Component-test completed with result: Succeeded
        ```

     - Is there a time difference between running your pipeline with a local runner and with a Github provided runner?

___

- Make the local runner run as a service

     Right now the runner is attached to a bash session in VS code. If you kill that session, the runner will be stopped.
     So in order for us to have it running in the background, we need to run it as a service.

     - In the terminal where you are running the GH Actions runner, kill the current bash session with `Ctrl+C`
     - Follow the `Installing the service`, `Starting the service` and `Checking the status of the service` instructions on how to run the runner as a service here: https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service

     - Rerun the last actions run, or push another commit to trigger the pipeline to see the local runner still works.

Congratulations! You have now configured a local runner and used it in your pipeline!

### Resources
[Adding self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners)
