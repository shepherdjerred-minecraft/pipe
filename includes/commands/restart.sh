#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/start.sh"
source "${BASH_SOURCE%/*}/stop.sh"

restart() {

    name=""

    SHORT="n:"
    LONG="name:"

    # -temporarily store output to be able to check for errors
    # -activate advanced mode getopt quoting e.g. via “--options”
    # -pass arguments only via   -- "$@"   to separate them correctly
    PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
    if [[ $? -ne 0 ]]; then
        # e.g. $? == 1
        #  then getopt has complained about wrong arguments to stdout
        exit 2
    fi
    # use eval with "$PARSED" to properly handle the quoting
    eval set -- "$PARSED"

    # now enjoy the options in order and nicely split until we see --
    while true; do
        case "$1" in
            -n|--name)
                name="$2"
                shift 2
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Invalid argument"
                exit 3
                ;;
        esac
    done

    stop "$@"

    echo "Waiting for tmux session to end"
    until ! [ tmux has-session -t "$name" ]; do
        printf "."
        sleep 1s
    done

    start "$@"

}