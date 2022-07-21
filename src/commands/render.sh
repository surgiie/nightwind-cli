name: render
help: Render the project .nightwind template files.
filename: commands/render.sh
catch_all: true
group: Template
filters:
  - is_laravel_directory
  - is_initialized
  - requires_variables
dependencies:
  - find
flags:
- long: --rebuild
  help: Rebuild the nightwind/renderer image.
- long: --remove
  help: Remove the nightwind/renderer image when done.
---
#!/bin/bash
set -e

if [[ "$(docker images -q nightwind/renderer 2>/dev/null)" == "" ]] || [[ ${args[--rebuild]} == '1' ]]; 
then
    cd "$(get_cli_path)/src/renderer"
    cyan "INFO: Building docker image for nightwind/renderer."
    docker build -t nightwind/renderer --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
    cd -
fi

## copy over project .nightwind directory and .env file to render templates from
rm -rf $(get_cli_path)/src/renderer/.project
cp -R $PWD/.nightwind $(get_cli_path)/src/renderer/.project
cp $PWD/.env $(get_cli_path)/src/renderer/.project/.env

## Mounted volume directories get mounted as root, a work around as commented here: https://github.com/moby/moby/issues/2259#issuecomment-26564115
mkdir -p $PWD/.nightwind/rendered
chown $(id -u):$(id -g) $PWD/.nightwind/rendered

docker run --rm  \
    --volume "$(get_cli_path)/src/renderer:/home/nightwind" \
    --volume "$PWD/.nightwind/rendered:/home/nightwind/.project/rendered" \
    --workdir /home/nightwind \
    nightwind/renderer ./entrypoint "${other_args[@]}"

## cleanup
rm -rf $(get_cli_path)/src/renderer/.project

if [[ ${args[--remove]} == '1' ]];
then
    docker image rm nightwind/renderer
fi

set +e