#!/bin/bash
echo "$docker_password" | docker login --username "$docker_username" --password-stdin
echo 'docker push "$docker_username/micronaut-app:1.0-${GIT_COMMIT::4}"' 
docker push "$docker_username/micronaut-app:1.0-${GIT_COMMIT::4}" 
docker push "$docker_username/micronaut-app:latest" &
wait