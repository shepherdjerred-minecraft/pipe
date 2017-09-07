#!/usr/bin/env bash

create() {
    echo Creating server...
    version="latest"
    name=""
    port="25565"
    serverType="spigot"
    base=""

    SHORT="n:p:t:v:b:"
    LONG="name:,port:,type:,version:,base:"

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
            -p|--port)
                port="$2"
                shift 2
                ;;
            -t|--type)
                serverType="$2"
                shift 2
                ;;
            -v|--version)
                version="$2"
                shift 2
                ;;
            -b|--base)
                base="$2"
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

    if [ "$name" == "" ]; then
        # No name give
        # Finally my random name generator has a chance to shine!
        name="$(generateRandomName)"
    fi

    if [ "$base" != "" ]; then
        # We need to copy over the needed files
        echo "This feature isn't ready yet!"
    fi

    echo "Name: $name"
    echo "Port: $port"
    echo "Type: $serverType"
    echo "Version: $version"
    echo "Base: $base"

    mkdir -p "$servers_path/$name/"

    if [ "$serverType" == "spigot" ]; then
        createSpigot "$name" "$port" "$version"
    elif [ "$serverType" == "bungeecord" ]; then
        createBungeecord "$name" "$port" "$version"
    else
        echo "Invalid type"
        exit 3
    fi
    
    echo "Server $name created"
}

createSpigot() {
    name="$1"
    port="$2"
    version="$3"

    if [ "$version" == "latest" ]; then
        download "spigot" "latest"
        update "$name"
    else
        if [ ! -f "$download_path/buildtools/spigot-$version.jar" ]; then
            echo "Spigot $version not downloaded; downloading it"
            download "spigot" "$version"
        else
            echo "Spigot $version already downloaded; copying it"
        fi
        cp "$download_path/buildtools/spigot-$version.jar" "$servers_path/$name/spigot.jar"
    fi
    printf "eula=true" > "$servers_path/$name/eula.txt"
    printf "server-port=$port" > "$servers_path/$name/server.properties"
    printf "max_ram=1G\nmin_ram=512M/server-port=$port" > "$servers_path/$name/pipe.cfg"
}

createBungeecord() {
    name="$1"
    port="$2"
    version="$3"
    download "bungeecord" "$version"
    cp "$download_path/BungeeCord.jar" "$servers_path/$name/BungeeCord.jar"
    printf "max_ram=512M\nmin_ram=128M" > "$servers_path/$name/pipe.cfg"
    # We also need to set the config port here
}
