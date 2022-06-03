name: npm
alias: np
help: Proxy a npm command to the app service container.
catch_all: true
filename: commands/npm.sh
filters:
- is_laravel_directory
- docker_running
- requires_variables
dependencies:
  - docker
flags:
- long: --container
  arg: container
  default: app
  help: Specify container name if custom. 
args:
- name: command
  help: The command to execute. 

---
#!/bin/bash
set -e

variables_file=".nightwind/variables.yaml"
eval $(yaml_load $variables_file)

container="${args[--container]}"
command="${args[command]}"
container="$tag_prefix-${container/$tag_prefix-/''}"

cyan "Running: docker exec -it "$container" npm $command $other_args"
docker exec -it $container npm $command $other_args

set +e