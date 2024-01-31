#!/bin/bash
echo "$secrets.GITHUB_TOKEN" | docker login ghcr.io --username "$GITHUB_ACTOR" --password-stdin
docker push "ghcr.io/$docker_username/micronaut-app:1.0-${GIT_COMMIT::8}" 
docker push "ghcr.io/$docker_username/micronaut-app:latest" &
wait
