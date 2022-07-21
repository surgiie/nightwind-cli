name: app
filename: commands/app.sh
help: Exec a command on the app container.
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

exec_command app ${args[command]} other_args

set +e