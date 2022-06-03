name: exec
alias: e
filename: commands/exec.sh
help: Exec a command on a container.
catch_all: true
args:
- name: container
  help: The target container to exec command. Can optionally exclude your project prefix.
  required: true
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

exec_command ${args[container]} ${args[command]} other_args

set +e