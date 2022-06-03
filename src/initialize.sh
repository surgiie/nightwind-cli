# Bootstrap things before executing command.
# ensure .env file is sourced for this project.
if [ -f ./.env ]
then
    set -o allexport
    source ./.env
    set +o allexport
fi
