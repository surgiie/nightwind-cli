name: mysql
filename: commands/mysql.sh
help: Exec a command on the mysql container.
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

exec_command mysql ${args[command]} other_args

set +e