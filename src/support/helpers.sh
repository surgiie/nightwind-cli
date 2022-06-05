#!/bin/bash

#---
## Get the absolute root path to where this cli exists.
#---
get_cli_path(){
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
}

#---
## Parses a string value from .nightwind/variables.json
#---
parse_variable_json_string_value(){
    result="$(grep -o "\"${1}\": \"[^\"]*" .nightwind/variables.json | grep -o '[^"]*$')"
    echo $result
}

#---
## Extract the value of docker_tag_namespace from .nightwind/variables.json
#---
get_docker_tag_namespace(){
    result="$(parse_variable_json_string_value docker_tag_namespace)"
   
    echo $result
}

#---
## Generate a file if it doesnt exist or by force.
#---
write_file(){
    file=$1
    contents=$3
    force=$4

    if [[ $force != "1" ]] && [[ -f "$file" ]]; 
    then
        yellow "WARN: File $file already exists."
    fi

    if [[ $force == "1" || ! -f "$file" ]]; 
    then
        cyan "INFO: Saved file $file."
        echo "$contents" > $file
    fi
}
#---
## Prompt for confirmation, to be used in if statements.
#---
confirm() {
    message="${1:-Are you sure? [y/N]} "
    yellow "$message"
    read -r -p '' response
    echo -ne "\r"
    case "$response" in
    [yY][eE][sS] | [yY])
        true
        ;;
    *)
        false
        ;;
    esac
}
#---
## Run a .nightwind/hooks script if it exists and is executable.
#---
run_hook(){
    hook="$1"
    if [ -f ".nightwind/hooks/$hook" ];
    then
        if [[  -x ".nightwind/hooks/$hook" ]];
        then
            cyan "INFO: Running $hook hook script"
            .nightwind/hooks/$hook
        else
            red "ERROR: Hook file not executable: .nightwind/hooks/$hook"
            exit 1;
        fi
    fi

}

#---
## Exec a command on a container.
#---
exec_command(){
    local container="$1"
    local command="$2"
    local -n other_arguments="$3"

    docker_tag_namespace="$(get_docker_tag_namespace)"

    container="$docker_tag_namespace-${container/$docker_tag_namespace-/''}"

    cyan "INFO: Running: docker exec -it "$container" "$command" $other_args"
    docker exec -it "$container" $command $other_args
}

#---
## Build all or a specific .nightwind/rendered/dockerfiles image(s).
## Where target matches the prefix from the file:
## e.g .nightwind/rendered/dockerfiles/<target>.Dockerfile
#---
build_project_images(){
    local target="$1"
    local -n build_args="$2"
    
    docker_tag_namespace="$(get_docker_tag_namespace)"

    if [ -z $target ]
    then
        paths="$(find ".nightwind/rendered/dockerfiles" -type f -name '*.Dockerfile')"
    else
        paths=(".nightwind/rendered/dockerfiles/$target.Dockerfile")
    fi


    for dockerfile in $paths; 
    do
        filename="${dockerfile##*dockerfiles/}" ## get relative path
        target="${filename%%.*}"
        
        cyan "INFO: Running: docker build -t $docker_tag_namespace/$target -f .nightwind/rendered/dockerfiles/$filename . $build_args"
        docker build -t $docker_tag_namespace/$target -f ".nightwind/rendered/dockerfiles/$filename" . $build_args 
    done
}