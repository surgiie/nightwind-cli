#!/bin/bash

## check that docker is running.
filter_docker_running() {
  docker info > /dev/null 2>&1 || echo "$(red DependencyError:) $(bold Docker is not running.)"
}

## check that .nightwind folder is initialized
filter_is_initialized(){
    if [ ! -d ".nightwind" ] || [ -z "$(ls -A ".nightwind/templates")" ]
    then
        echo "$(red This project does not appear to be initialized. Run: \`nightwind init\`)"
    fi
}

## check that .env file is present.
filter_env_file_required(){
    if [ ! -f ".env" ]
    then 
        echo "$(red  Project .env file is missing.)"
    fi
}

## check that .env file is present.
filter_requires_docker_tag_namespace(){
    result="$(get_docker_tag_namespace)"
    if [ -z "$result" ];
    then
        echo "$(red The docker_tag_namespace variable is empty or couldnt be parsed from variables.json. Bad quotes/json\?)"
    fi
}

## check that .env file is present.
filter_is_laravel_directory(){
    if  [ ! -f "composer.json" ] || ! grep -q "laravel/framework" composer.json 
    then
        echo "$(red Your current directory doesnt appear to be a laravel/framework project.)"
    fi
}

## check that variables.json file is present.
filter_requires_variables(){
    if [ ! -f ".nightwind/variables.json" ]
    then 
        echo "$(red  Command requires the .nightwind/variables.json file to perform task\(s\). Did you run \`nightwind init\`?)"
    fi
}

## check that template files have been rendered
filter_requires_rendered_files(){
    if [ ! -d ".nightwind/rendered" ] || [ -z "$(ls -A ".nightwind/rendered")" ]
    then
        echo "$(red The template files have not been rendered/nothing to render. Did you run \`nightwind render\`)"
    fi
}
