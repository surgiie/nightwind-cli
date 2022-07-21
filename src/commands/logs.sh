name: logs
help: Tail a project container logs.
catch_all: true
filename: commands/logs.sh
group: Docker
args:
- name: container
  help: The target container to tail logs.
  default: app
dependencies:
  - docker
filters:
  - is_laravel_directory
  - docker_running
  - requires_variables
---
#!/bin/bash
set -e

docker_tag_namespace="$(get_docker_tag_namespace)"
container="${args[container]}"
container="$docker_tag_namespace-${container/$docker_tag_namespace-/''}"

cyan "INFO: Running: docker logs "$container" --follow --timestamps $other_args"
docker logs "$container" --follow --timestamps $other_args

set +e