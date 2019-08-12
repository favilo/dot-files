##
# Configures your shell with some convenient Simon tools
# specific to the events-api repo
##

##
# Search the repo, ignore virtual envs and build dirs
##
function grok-events-api() {
    grep -r --exclude '*/.venv/*' --exclude '*/.build/*' "$@" *
}

##
# Search all python file in repo, ignore virtual envs and build dirs
##
function grok-events-api-py() {
    grep -r --exclude '*/.venv/*' --exclude '*/.build/*' --include '*.py' "$@" *
}

