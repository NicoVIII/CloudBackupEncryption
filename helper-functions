# Printing functions
function printHelper {
    local message=$1
    local verbose=$2
    local error=$3

    if [ "$_arg_quiet" == "off" ]; then
        if [ $verbose == "off" ] || [ "$_arg_verbose" == "on" ]; then
            if [ $error == "on" ]; then
                echo >&2 "$message"
            else
                echo "$message"
            fi
        fi
    fi
}

function printLog {
    local message=$1

    printHelper "$message" "off" "off"
}

function printVerbose {
    local message=$1

    printHelper "$message" "on" "off"
}

function printError {
    local message=$1

    printHelper "$message" "off" "on"
}

function dependencyMissing {
    local command=$1

    ! command -v "$command" >/dev/null 2>&1 && printError "$command command not found!"
}

function execute {
    local command=$1

    printVerbose "> $command"
    eval "$command"
}
