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
dependencies:
  - docker
  - find
flags:
- long: --force
  help: Overwrite existing files.
---
#!/bin/bash
set -e


# run_hook "before_up"

cyan "Checking docker images."

## loop rendered docker files and build images
docker_tag_namespace="$(parse_variable_json_value docker_tag_namespace)"

echo "TAG NAMESPACE: $docker_tag_namespace"
# for dockerfile in $(find ".nightwind/rendered/dockerfiles" -type f -name '*.Dockerfile'); 
# do
#     target="${dockerfile##*dockerfiles/}" 
#     target=${target%.Dockerfile*}
#     if [[ "$(docker images -q $tag_prefix/$target 2>/dev/null)" == "" ]]; then
#         yellow "WARNING: Docker image $tag_prefix/$target doesnt exist, building."
#         declare -A empty_args=() # required by the build_project_images helper
#         build_project_images "$tag_prefix" "$target" empty_args
#     fi

# done

# cyan "Checking available compose files."

# yaml_file_arg="-f .nightwind/rendered/compose/app.yaml"
# env_yaml_file=".nightwind/rendered/compose/$APP_ENV.env.yaml"

# if [ -f "$env_yaml_file" ]; then
#     path="${env_yaml_file##*.nightwind/}" 
#     yaml_file_arg="${yaml_file_arg} -f $env_yaml_file"
# fi


# for yaml in $(find ".nightwind/rendered/compose" -type f -name '*.yaml' ! -name app.yaml ! -name $APP_ENV.env.yaml ! -name *.env.yaml); 
# do
#     path="${yaml##*.nightwind/}" 
#     path=".nightwind/$path"
#     yaml_file_arg="${yaml_file_arg} -f $path"
#     target="${path%%.*}"
# done


# cyan "Starting services."

# docker compose $yaml_file_arg up -d $other_args

# # run hook if successful.
# if [ $? -eq 0 ]; then
#     run_hook "after_up"
# fi


# lightgreen "Started services!"
