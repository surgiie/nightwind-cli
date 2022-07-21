name: init
help: Initialize project .nightwind directory & template files.
filename: commands/init.sh
group: Template
filters:
  - is_laravel_directory
flags:
- long: --force
  help: Overwrite existing files.
dependencies:
  - find
---
#!/bin/bash

set -e

domain=${args[--domain]}

mkdir -p ".nightwind"

for file in $(find $(get_cli_path)/stubs -type f); 
do 
    relative_path="${file##*stubs/}" 
    destination_path=".nightwind/$relative_path" 

    mkdir -p "$(dirname $destination_path)"
    
    write_file $destination_path ".nightwind/$stub_type/$relative_path" "$(cat $file)" ${args[--force]}
done

if [ ! -f ".nightwind/.gitignore" ];
then 
    echo -e "rendered/" > ".nightwind/.gitignore"
fi

chmod +x .nightwind/hooks/*

lightgreen "Initialized .nightwind directory & files."

set +e