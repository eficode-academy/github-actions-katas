#!/bin/bash
set -e
if [[ -z "${github_username}" ]]; then
	echo "ERROR: github_username must be set in the environment"
	exit 1
fi
if [[ -z "${github_password}" ]]; then
	echo "ERROR: github_password must be set in the environment"
	exit 1
fi
echo "${github_password}" | docker login ghcr.io --username "${github_username}" --password-stdin
docker push "ghcr.io/${github_username}/micronaut-app:1.0-${GIT_COMMIT::8}"
docker push "ghcr.io/${github_username}/micronaut-app:latest" &
wait
