name: logs
alias: l
help: Tail a project container logs.
catch_all: true
filename: commands/logs.sh
args:
- name: container
  help: The target container to tail logs. Can optionally exclude your project prefix.
  required: true
dependencies:
  - docker
filters:
  - is_laravel_directory
  - docker_running
  - requires_variables
---
#!/bin/bash
set -e

variables_file=".nightwind/variables.yaml"
eval $(yaml_load $variables_file)
container="${args[container]}"
container="$tag_prefix-${container/$tag_prefix-/''}"
cyan "Running: docker logs "$container" --follow --timestamps $other_args"

docker logs "$container" --follow --timestamps $other_args

set +e