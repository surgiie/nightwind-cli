name: npm
alias: np
help: Proxy a npm command to the app service container.
catch_all: true
filename: commands/npm.sh
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

exec_command ${args[--container]} "npm ${args[command]}" other_args

set +e