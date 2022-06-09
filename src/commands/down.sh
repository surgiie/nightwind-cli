name: down
alias: d
help: Stop docker compose services.
catch_all: true
filename: commands/down.sh
filters:
  - is_laravel_directory
  - docker_running
  - requires_variables
  - requires_rendered_files
  - requires_docker_tag_namespace
dependencies:
  - docker
  - find
---
#!/bin/bash
set -e

run_hook "before_down"

cyan "INFO: Checking available compose files."
yaml_file_arg="$(get_docker_compose_yaml_files_argument)"

cyan "INFO: Running: docker compose $yaml_file_arg down $other_args"
docker compose $yaml_file_arg down $other_args

# run hook if successful.
if [ $? -eq 0 ]; then
    run_hook "after_down"
fi

lightgreen "Stopped services!"
