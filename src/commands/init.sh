name: init
alias: i
help: Initialize project .nightwind directory & template files.
filename: commands/init.sh
filters:
  - is_laravel_directory
  - env_file_required
flags:
- long: --force
  help: Overwrite existing files.
dependencies:
  - find
  - sed

---
#!/bin/bash

# Initialize project .nightwind folder.
set -e

domain=${args[--domain]}

mkdir -p ".nightwind"

## generate stubs directory/files.
for file in $(find $(get_cli_path)/stubs -type f); 
do 
    relative_path="${file##*stubs/}" 
    destination_path=".nightwind/$relative_path" 

    mkdir -p "$(dirname $destination_path)" ## ensure parent directory exists
    
    write_file $destination_path ".nightwind/$stub_type/$relative_path" "$(cat $file)" ${args[--force]}
done

# create a .gitignore to ignore rendered files
if [ ! -f ".nightwind/.gitignore" ];
then 
    echo -e "rendered/" > ".nightwind/.gitignore"
fi

lightgreen "Initialized .nightwind directory & files."

set +e