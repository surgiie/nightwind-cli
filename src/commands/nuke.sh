
name: nuke
alias: n
help: Nuke all project docker compose services & volumes.
catch_all: true
filename: commands/nuke.sh
filters:
  - is_laravel_directory
  - docker_running
  - env_file_required
  - requires_rendered_files
dependencies:
  - docker
  - find
---
#!/bin/bash

set -e

if [ ! -d ".nightwind/rendered/compose" ] || [ -z "$(ls -A ".nightwind/rendered/compose")" ]; then
   echo "$(red .nightwind/rendered/compose doesnt exist or is empty, nothing to nuke.)"
   exit 1;
fi


nuke(){
    yaml_file_arg="-f .nightwind/rendered/compose/app.yaml"
    
    for yaml in $(find ".nightwind/rendered/compose" -type f -name '*.yaml' ! -name app.yaml); 
    do
        path="${yaml##*.nightwind/}" 
        path=".nightwind/$path"
        yaml_file_arg="${yaml_file_arg} -f $path"
        target="${path%%.*}"
    done

    cyan "INFO: Running: docker kill \$(docker compose $yaml_file_arg ps -q)"
    docker kill $(docker compose $yaml_file_arg ps -q)
    
    cyan "INFO: Running: docker rm --force  \$(docker compose $yaml_file_arg ps -q --all)"
    docker rm --force  $(docker compose $yaml_file_arg ps -q --all)

    cyan "INFO: Running: docker system prune --all --volumes --force"
    docker system prune --all --volumes --force

    lightgreen "Stopped and removed project docker resources."
}

if [ $APP_ENV != "local" ];
then
    yellow "*********************************************************************************************"
    yellow "                              W A R N I N G                                                  "
    yellow "                         Non-Local Env: $APP_ENV                                             "
    yellow "      This command stops & removes ALL of your docker compose services & resources           "
    yellow "                    and runs docker system prune --all --volumes --force                     "
    yellow "                                                                                             "
    yellow "*********************************************************************************************"

    if confirm "Continue?";
    then
        nuke
    else
        red "Aborted."
    fi
else
    nuke
fi

set +e
