#!/usr/bin/env bash

start() {
    name=""
    force="false"
    all="false"

    SHORT="n:fa"
    LONG="name:,force,all"

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
            -f|--force)
                force="true"
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
    	echo "Starting all servers"
    	cd "$servers_path"
    	for d in */ ; do
            if [ -f "$d/pipe.cfg" ]; then
            	start "-n" "${d%/}"
            fi
        done
        exit 3
    fi

    echo "Starting $name..."

    cd "$servers_path/$name"
    source pipe.cfg

    if [ "$force" == "true" ]; then
        echo "Killing any processes on the server port"
        fuser -n tcp -k "${port}"

    if [ tmux has-session -t "$name" ]; then
        echo "That server is already up"
        exit 3
    fi;

    if [ -f "spigot.jar" ]; then
        tmux new -d -s "$name" "java -Xms${min_ram} -Xmx${max_ram} -jar spigot.jar"
    elif [ -f "BungeeCord.jar" ]; then
        tmux new -d -s "$name" "java -Xms${min_ram} -Xmx${max_ram} -jar BungeeCord.jar"
    else
        echo "It doesn't look like there's a server here..."
        exit 3
    fi;

    cd -
}