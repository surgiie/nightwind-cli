name: up
alias: u
help: Start docker compose services.
catch_all: true
filename: commands/up.sh
filters:
  - is_laravel_directory
  - docker_running
  - env_file_required
  - requires_variables
  - requires_rendered_files
  - requires_docker_tag_namespace
dependencies:
  - docker
  - find
flags:
- long: --force
  help: Overwrite existing files.
---
#!/bin/bash
set -e

run_hook "before_up"

cyan "INFO: Checking built docker images."

## loop rendered docker files and build images
docker_tag_namespace="$(get_docker_tag_namespace)"

for dockerfile in $(find ".nightwind/rendered/dockerfiles" -type f -name '*.Dockerfile'); 
do
    target="${dockerfile##*dockerfiles/}" 
    target=${target%.Dockerfile*}

    if [[ "$(docker images -q $docker_tag_namespace/$target 2>/dev/null)" == "" ]]; then
        yellow "WARNING: Docker image $docker_tag_namespace/$target doesnt exist, building image for start up."
        declare -A empty_args=() # required by the build_project_images helper
        build_project_images $target empty_args
    fi
done

cyan "INFO: Checking available compose files."

yaml_file_arg="$(get_docker_compose_yaml_files_argument)"

cyan "INFO: Running: docker compose $yaml_file_arg up -d $other_args"
docker compose $yaml_file_arg up -d $other_args

run_hook "after_up"

lightgreen "Started services!"

set +e
