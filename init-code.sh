#!/bin/bash
# Printing functions
function printHelper {
    local message=$1
    local verbose=$2
    local error=$3
    local ending=$4

    if [ "$_arg_quiet" = "off" ]; then
        if [ "$verbose" = "off" ] || [ "$_arg_verbose" = "on" ]; then
            if [ "$error" = "on" ]; then
                echo >&2 -en "$message$ending"
            else
                # Allow complete overwriting of progress bar
                printf "%-35s$ending" "$message"
            fi
        fi
    fi
}

function printLog {
    local message=$1
    local ending=$2

    printHelper "$message" "off" "off" "$ending"
}

function printLogN {
    local message=$1

    printLog "$message" "\n"
}

function printLogR {
    local message=$1

    printLog "$message" "\r"
}

function printVerbose {
    local message=$1
    local ending=$2

    printHelper "$message" "on" "off" "$ending"
}

function printVerboseN {
    local message=$1

    printVerbose "$message" "\n"
}

function printError {
    local message=$1
    local ending=$2

    printHelper "$message" "off" "on" "$ending"
}

function printErrorN {
    local message=$1

    printError "$message" "\n"
}

function validifyLink {
    local path=$1

    readlink -f "$path" || (printErrorN "$path could not be validified!" && exit 4)
}

function validifyVirtualLink {
    local path=$1

    readlink -m "$path"
}

readonly inFolder=$(validifyLink "$_arg_input")
readonly outFolder=$(validifyLink "$_arg_output")
currSize=0

# Start of program
printLogN "$progname $version - $libname"

# Prepare tmp folder
readonly rootFolder=$(dirname $outFolder)
if [ -d "$rootFolder/tmp" ]; then
    for i in {1..9}
    do
        if [ ! -d "$rootFolder/tmp$i" ]; then
            tmp="tmp$i"
            break
        fi
    done
else
    tmp="tmp"
fi
readonly tmpFolder=$(validifyLink "$rootFolder/$tmp")
mkdir "$tmpFolder"
