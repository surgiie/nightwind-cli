#!/bin/bash
name: composer
help: Proxy a composer command to the app service container.
catch_all: true
filename: commands/composer.sh
group: Docker
filters:
- is_laravel_directory
- docker_running
- requires_variables
- requires_docker_tag_namespace
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

exec_command ${args[--container]} "composer ${args[command]}" other_args

set +e