#!/usr/bin/env bash

update() {
    name=""
    stop="false"
    all="false"

    SHORT="n:a"
    LONG="name:,a"

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
            -a|--all)
                all="true"
                shift
                ;;
            -s|--stop)
                stop="true"
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
        echo "Updating all servers"
        cd "$servers_path"
        for d in */ ; do
            if [ -f "$d/pipe.cfg" ]; then
                cd -
                update "-n" "${d%/}"
                cd "$servers_path"
            fi
        done
        exit 3
    fi

    echo "Updating $name to the last downloaded jar"

    if [ -f "$servers_path/$name/spigot.jar" ]; then
        updateSpigot "$name"
    elif [ -f "$servers_path/$name/BungeeCord.jar" ]; then
        updateBungeecord "$name"
    else
        echo "It doesn't look like there's a server here..."
        exit 3
    fi;
}

updateSpigot() {
    name="$1"
    cd "$download_path/buildtools/"
    cp "$(ls -v spigot*.jar | tail -n 1)" "$servers_path/$name/spigot.jar"
    cd -
}

updateBungeecord() {
    name="$1"
    cp "$download_path/BungeeCord.jar" "$servers_path/$name/BungeeCord.jar"
}