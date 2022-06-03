name: build
alias: b
help: Build docker image(s) in .nightwind/dockerfiles.
catch_all: true
filename: commands/build.sh
filters:
  - is_laravel_directory
  - docker_running
  - requires_variables
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

docker_tag_namespace="$(grep -o '"docker_tag_namespace": "[^"]*' .nightwind/variables.json | grep -o '[^"]*$')"

if [ -z $docker_tag_namespace ];
then
    echo "$(red MissingVariableError:) $(bold The docker_tag_namespace json variable is required to build images.)"
    exit 1;
fi

build_project_images "$target" other_args

set +e