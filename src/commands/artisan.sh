name: artisan
help: Proxy an artisan command to the app service container.
catch_all: true
filename: commands/artisan.sh
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

exec_command ${args[--container]} "php artisan ${args[command]}" other_args

set +e