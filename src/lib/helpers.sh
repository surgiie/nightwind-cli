#!/bin/bash
get_cli_path(){
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
}

parse_variable_json_value(){
    echo grep -o '"$1": "[^"]*' .nightwind/variables.json | grep -o '[^"]*$'
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

    variables_file=".nightwind/variables.yaml"
    eval $(yaml_load $variables_file)
    
    container="$tag_prefix-${container/$tag_prefix-/''}"

    cyan "Running: docker exec -it "$container" "$command" $other_args"
    docker exec -it "$container" $command $other_args
}

build_project_images(){
    local tag_prefix="$1"
    local target="$2"
    local -n build_args="$3"

    # if no target has been specified, build all available files.
    if [ -z $target ]
    then
        for dockerfile in $(find ".nightwind/rendered/dockerfiles" -type f -name '*.Dockerfile'); 
        do
            filename="${dockerfile##*dockerfiles/}" ## get relative path
            target="${filename%%.*}"
            
            cyan "Running: docker build -t $tag_prefix/$target -f .nightwind/rendered/dockerfiles/$filename . $build_args"
            docker build -t $tag_prefix/$target -f ".nightwind/rendered/dockerfiles/$filename" . $build_args 
        done
    else
        dockerfile=".nightwind/rendered/dockerfiles/$target.Dockerfile"
        if [ ! -f $dockerfile ];
        then
            red "$target.Dockerfile does not exist in .nightwind/rendered/dockerfiles"
            exit 1
        fi
        cyan "Running: docker build -t $tag_prefix/$target -f $dockerfile . $build_args"
        docker build -t $tag_prefix/$target -f $dockerfile . $build_args 
    fi
}