#!/usr/bin/env bash

stop() {
    name=""
    killServer="false"
    all="false"

    SHORT="n:ka"
    LONG="name:,kill,all"

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
            -k|--kill)
                killServer="true"
                shift
                ;;
            -a|--all)
                all="true"
                shift
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

    if [ "$all" == "true" ]; then
        echo "Stopping all servers"
        cd "$servers_path"
        for d in */ ; do
            if [ -f "$d/pipe.cfg" ]; then
                stop "-n" "${d%/}"
            fi
        done
        exit 3
    fi

    echo "Stopping $name..."

    cd "$servers_path/$name"
    source pipe.cfg

    if ! [ tmux has-session -t "$name" ]; then
        echo "That server isn't up right now"
        exit 3
    fi;

    if [ "$killServer" == "true" ]; then
        tmux kill-session -t "$name"
        exit 3
    fi;

    if [ -f "spigot.jar" ]; then
        tmux send -t "$name" stop ENTER
    elif [ -f "BungeeCord.jar" ]; then
        tmux send -t "$name" e
        tmux send -t "$name" nd ENTER
    else
        echo "It doesn't look like there's a server here..."
        exit 3
    fi;

    cd -
}