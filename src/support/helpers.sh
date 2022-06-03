#!/bin/bash
get_cli_path(){
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
}

parse_variable_json_value(){
    result="$(grep -o "\"${1}\": \"[^\"]*" .nightwind/variables.json | grep -o '[^"]*$')"
    echo $result
}

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

run_hook(){
    hook="$1"
    if [ -f ".nightwind/hooks/$hook" ];
    then
        if [[  -x ".nightwind/hooks/$hook" ]];
        then
            cyan "Running hook [$hook] script:"
            .nightwind/hooks/$hook
        else
            red "Hook file not executable: .nightwind/hooks/$hook"
            exit 1;
        fi
    fi

}

exec_command(){
    local container="$1"
    local command="$2"
    local -n other_arguments="$3"

    docker_tag_namespace="$(parse_variable_json_value docker_tag_namespace)"

    
    container="$docker_tag_namespace-${container/$docker_tag_namespace-/''}"

    cyan "Running: docker exec -it "$container" "$command" $other_args"
    docker exec -it "$container" $command $other_args
}

build_project_images(){
    local target="$1"
    local -n build_args="$2"
    
    docker_tag_namespace="$(parse_variable_json_value docker_tag_namespace)"

    # if no target has been specified, build all available files.
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
        
        cyan "Running: docker build -t $docker_tag_namespace/$target -f .nightwind/rendered/dockerfiles/$filename . $build_args"
        docker build -t $docker_tag_namespace/$target -f ".nightwind/rendered/dockerfiles/$filename" . $build_args 
    done
}