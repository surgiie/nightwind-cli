
name: nuke
help: Nuke all project docker compose services. 
catch_all: true
filename: commands/nuke.sh
group: Docker
filters:
  - is_laravel_directory
  - docker_running
  - env_file_required
  - requires_rendered_files
flags:
- long: --force
  help: Force nuke in non local environments.
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
    yaml_file_arg="$(get_docker_compose_yaml_files_argument)"

    cyan "INFO: Running: docker-compose $yaml_file_arg down -v --rmi all"
    docker-compose $yaml_file_arg down -v --rmi all

    lightgreen "Stopped and removed project docker resources."
}

if [ $APP_ENV != "local" ] && [[ ${args[--force]} != "1" ]];
then
    yellow "*********************************************************************************************"
    yellow "                              W A R N I N G                                                  "
    yellow "                         Non-Local Env: $APP_ENV                                             "
    yellow "      This command stops & removes ALL of your docker compose services & resources           "
    yellow "      and also runs docker system prune, this is meant for a local env, please use with      "
    yellow "      caution as docker system prune removes things not associated with project.             "
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
