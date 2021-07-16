#! /bin/bash
[[ -z "${docker_username}" ]] && DockerRepo='' || DockerRepo="${docker_username}/"
docker_username=$DockerRepo docker-compose -f component-test/docker-compose.yml --project-directory . -p ci up --build --exit-code-from test