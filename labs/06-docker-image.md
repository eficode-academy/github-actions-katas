## Making docker images

Often we also want to have our application packaged as a docker image for easy distribution. Lucky for us, Github Actions has nice support for Docker built in.

The following is an example of a job that builds a Docker image. Instead of specifying a `container: image` to run on, we now use a `machine: image` instruction to give us an environment where we can run actual docker commands:

```YAML

```

If you wanted to try this on the project, we have made two scripts: `ci/build-docker.sh` and `ci/push-docker.sh`
In order for this to work, two env. variables needs to be set: `docker_username` and `docker_password`. It can be done by adding below section on top of the file:

```YAML
env: 
  docker_username: ${{ secrets. docker_username }}
  docker_password: ${{ secrets. docker_password }}
```

### Tasks

1. Add a new job named `Docker-image` that requires the `Build` and `Test` jobs have been run.
2. Add `docker_username` and `docker_password` as environmental variables. 
3. Then run the `ci/build-docker.sh` and `ci/push-docker.sh` scripts with `export GIT_COMMIT="GA-$GITHUB_SHA"`.

> Hint: Remember that the job needs to run on specified system and is based on the results from previous jobs. 

> Hint: You can find lots of information about `$GITHUB_SHA` and the other environment variables provided by Github Actions in  https://docs.github.com/en/enterprise-server@2.22/actions/reference/environment-variables