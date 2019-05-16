#!/bin/bash
function dependencyMissing {
    local command=$1

    ! command -v "$command" >/dev/null 2>&1 && printErrorN "$command command not found!"
}

function execute {
    local command=$1

    printVerboseN "> $command"
    eval "$command"
}

function printProgress {
    if [ "$_arg_quiet" = "off" ]; then
        local ratio=$[currSize * 100 / size]

        local message=" ["

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
            echo -en "$message\r"
        fi
    fi
}

function addToProgress {
    local addBytes=$1

    if [ "$_arg_quiet" = "off" ]; then
        currSize=$[currSize + addBytes]
        printProgress
    fi
}
