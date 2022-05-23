#!/bin/bash

## check that docker is running.
filter_docker_running() {
  docker info > /dev/null 2>&1 || echo "$(red DependencyError:) $(bold Docker is not running.)"
}

## check that .env file is present.
filter_env_file_required(){
    if [ ! -f ".env" ]
    then 
        echo "$(red  Project .env file is missing.)"
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
        echo "$(red The template files have not been rendered. Run: \`nightwind render\`)"
    fi
}
