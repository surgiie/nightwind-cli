name: build
help: Build docker image(s) in .nightwind/dockerfiles.
catch_all: true
filename: commands/build.sh
group: Docker
filters:
  - is_laravel_directory
  - docker_running
  - requires_variables
  - requires_docker_tag_namespace
dependencies:
  - docker
  - find
args:
- name: target
  help: The image to build, if excluded will build all in the dockerfiles directory. Should exist in .nightwind/dockerfiles/<target>.Dockerfile
---
#!/bin/bash

set -e

target="${args[target]}"

if [ ! -d ".nightwind/rendered/dockerfiles" ];
then
    echo "$(red .nightwind/rendered/dockerfiles doesnt exist, nothing to build.)"
    exit 1
fi

docker_tag_namespace="$(get_docker_tag_namespace)"
build_project_images "$target" other_args

set +e