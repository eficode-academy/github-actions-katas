#! /bin/bash
if [[ -z "${github_username}" ]]; then
	echo "ERROR: github_username must be set in the environment"
	exit 1
fi
[[ -z "${github_username}" ]] || DockerRepo="${github_username}/"
github_username=$DockerRepo docker compose -f performance-test/docker-compose.yml --project-directory . -p ci up --build --exit-code-from test