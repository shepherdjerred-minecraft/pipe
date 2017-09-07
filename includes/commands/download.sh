#!/usr/bin/env bash

download() {

    mkdir -p "$download_path"

    case "$target" in
        "buildtools")
            downloadBuildTools
            ;;
        "spigot")
            downloadSpigot "$version"
            ;;
        "bungeecord")
            downloadBungeecord "$version"
            ;;
        "all")
            downloadBuildTools
            downloadSpigot "$@"
            downloadBungeecord "$@"
            ;;
        *)
            echo Invalid argument
            exit 3
            ;;
    esac
}

downloadBuildTools() {
    echo Downloading latest buildtools...
    mkdir -p "$download_path/buildtools"
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O "$download_path/buildtools/BuildTools.jar"
}

downloadSpigot() {
    version="latest"

    SHORT="v:"
    LONG="version:"

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
            -v|--version)
                version="$2"
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

    if [ ! -f "$download_path/buildtools/BuildTools.jar" ]; then
        echo "BuildTools isn't already downloaded, getting it now"
        download "buildtools"
    fi
    
    echo Running BuildTools...
    cd "$download_path/buildtools/"
    java -jar BuildTools.jar --rev "$version" > /dev/null
    cd -
}

downloadBungeecord() {
    version="lastSuccessfulBuild"

    SHORT="v:"
    LONG="version:"

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
            -v|--version)
                version="$2"
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

    if [ "$version" == "latest" ]; then
        $version = "lastSuccessfulBuild"
    fi

    wget http://ci.md-5.net/job/BungeeCord/$version/artifact/bootstrap/target/BungeeCord.jar -O "$download_path/BungeeCord.jar"
}