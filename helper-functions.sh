#!/bin/bash
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
                # Allow complete overwriting of progress bar
                printf "%-34s\n" "$message"
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

function printProgress {
    if [ "$_arg_quiet" = "off" ]; then
        encryptedBytes=$(cat "$encryptedBytesPipe")

        local ratio=$[encryptedBytes * 100 / size]

        local message="["

        for i in {1..25}
        do
            if [[ $[i * 4] -le $ratio ]]; then
                message+="#"
            else
                message+=" "
            fi
        done

        message+="] - $ratio%"

        if [[ $ratio -ge 100 ]]; then
            echo "$message"
        else
            echo -n "$message"
            echo -en "\r"
        fi
    fi
}

function addToProgress {
    local addBytes=$1

    if [ "$_arg_quiet" = "off" ]; then
        encryptedBytes=$(cat "$encryptedBytesPipe")
        encryptedBytes=$[encryptedBytes + addBytes]
        echo "$encryptedBytes" > $encryptedBytesPipe
        printProgress
    fi
}
