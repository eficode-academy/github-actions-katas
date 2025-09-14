#! /bin/bash
if [[ -z "${github_username}" ]]; then
	echo "ERROR: github_username must be set in the environment"
	exit 1
fi
# Pass the github_username through to docker-compose as the variable the compose file expects
# Compose references the username directly; include trailing slash in the value
[[ -z "${github_username}" ]] || DockerRepo="${github_username}/"
github_username=$DockerRepo docker compose -f component-test/docker-compose.yml --project-directory . -p ci up --build --exit-code-from test