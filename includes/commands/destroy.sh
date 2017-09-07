#!/usr/bin/env bash

destroy() {
    name=""
    immediate="false"

    SHORT="n:i"
    LONG="name:,immediate"

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
            -i|--immdiate)
                immediate="true"
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

    echo "Destroying $name... All files will be deleted"

    if [ "$immediate" == "false" ]; then
        echo "You have 5 seconds to cancel (Press CTRL+C)"
        sleep 5s
    fi;

    if [ -f "$servers_path/$name/pipe.cfg" ]; then
        tmux kill-session -t "$name"
        rm -rf "$servers_path/$name"
    else
        echo "It doesn't look like there's a server here..."
        exit 3
    fi;   
}