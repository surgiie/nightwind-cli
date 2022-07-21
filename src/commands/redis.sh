name: redis
filename: commands/redis.sh
help: Exec a command on the redis container.
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

exec_command redis ${args[command]} other_args

set +e