#!/usr/bin/env bash

send() {
    name=""
    command=""

    SHORT="n:c:"
    LONG="name:,command:"

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
            -c|--command)
                command="$2"
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

    if ! [ tmux has-session -t "$name" ]; then
        echo "That server isn't up right now"
        exit 3
    fi;

    echo "Sending $command to $name..."

    if [ -f "$servers_path/$name/spigot.jar" ]; then
        tmux send -t "$name $command" 
    elif [ -f "$servers_path/$name/BungeeCord.jar" ]; then
        tmux send -t "$name $command"
    else
        echo "It doesn't look like there's a server here..."
        exit 3
    fi;
}
