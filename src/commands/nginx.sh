name: nginx
filename: commands/nginx.sh
help: Exec a command on the nginx container.
catch_all: true
group: Docker
args:
- name: command
  help: The command to exec.
  default: bash
dependencies:
  - docker
filters:
  - is_laravel_directory
  - docker_running
  - requires_variables
---
#!/bin/bash
set -e

exec_command nginx ${args[command]} other_args

set +e