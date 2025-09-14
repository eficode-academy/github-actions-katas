#!/bin/bash
set -e
if [[ -z "${github_username}" ]]; then
	echo "ERROR: github_username must be set in the environment"
	exit 1
fi
[[ -z "${GIT_COMMIT}" ]] && Tag='local' || Tag="${GIT_COMMIT::8}"
REPO="ghcr.io/${github_username}/"
echo "${REPO}"
docker build -t "${REPO}micronaut-app:latest" -t "${REPO}micronaut-app:1.0-$Tag" app/
