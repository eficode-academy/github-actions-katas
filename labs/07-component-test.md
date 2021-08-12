## Component test 

After running `unit test` in exercise 2, now the time came to run `component test`, that requires your docker username and password as env, and a `ci/component-test.sh` script that runs a docker-compose file with component tests`


# Tasks 

1. Add job named `Component-test`, which will run a `ci/component-test.sh` script that runs a docker-compose file with component tests. 
2. This job needs to be dependent on `Docker-image` job. 
3. Similarly as in previous exercise `06-docker-image.md` it requires docker username and password. 


If you added the job succesfully, your pipeline should look like: 


