#!/bin/bash
set -e
echo "$docker_password" | docker login ghcr.io --username "$docker_username" --password-stdin
docker push "ghcr.io/$docker_username/micronaut-app:1.0-${GIT_COMMIT::8}" 
docker push "ghcr.io/$docker_username/micronaut-app:latest" &
wait
