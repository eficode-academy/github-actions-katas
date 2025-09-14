#!/bin/bash
set -euo pipefail
# Ensure github_username is provided
if [[ -z "${github_username:-}" ]]; then
	echo "ERROR: github_username must be set in the environment"
	exit 1
fi
# Strip any trailing slashes from the username to avoid ghcr.io// when empty or misformatted
USER="${github_username%/}"
if [[ -z "${USER}" ]]; then
	echo "ERROR: github_username is empty after trimming; please set a valid username (lowercase)"
	exit 1
fi
[[ -z "${GIT_COMMIT:-}" ]] && Tag='local' || Tag="${GIT_COMMIT::8}"
REPO="ghcr.io/${USER}/"
echo "Using repository prefix: ${REPO}"
docker build -t "${REPO}micronaut-app:latest" -t "${REPO}micronaut-app:1.0-$Tag" app/
