<img src="http://i.imgur.com/vnX7x7j.jpg">
<img src="http://i.imgur.com/8i1zHAK.png">

Pipe is a server wrapper for Spigot and BungeeCord. It allows your to easily create and manage minecraft server through the command line. It also serves various utility functions allowing you to easily update and backup servers, with a single command.

Pipe uses tmux to manage the servers, and provides a simple interface to manage those tmux sessions. You can focus on administering your server, while still maintaining a lightweight and functional enviornment, which other solutions such as McMyAdmin and Multicraft don't allow.

##Requirements
Most servers already include what we need, but in case they don't
* tmux
* getopt
* zip
* Java

##Installation
Installation is fairly simple

1. Download the [latest release](https://github.com/ShepherdJerred/pipe/releases)
2. Upload it to your server, anywhere will do
3. Edit the config file, set servers_path to where you'd like your servers stored
4. Use the program as instructed below

##Examples

Create a new server with the name MyServer running on port 25565

    ./pipe create -n MyServer -p 25565

Create a new BungeeCord server running on port 25565

    ./pipe create -n MyBungee -p 25565 -t bungeecord

Start a server named MyServer

    ./pipe start -n MyServer

Stop a server named MyServer

    ./pipe stop -n MyServer

##Usage

    ./pipe [command] [-arguments]
    
###Commands
    Command Name   Function/Description                    Accepted Arguments
    backup         Backup a server                         nas
    clean          Clean a servers log files               nac
    create         Create a new server                     nptvb
    destroy        Destroy a server                        nc
    download       Downlaod the latest version of a jar    tv
    restart        Restart a server                        na
    send           Send a command to a server              nad
    start          Start a server                          naf
    stop           Stop a server                           nak
    update         Update a server                         nas

###General Arguments
    Argument Name     Function/Description
    -n <name>         Server name
    -v <version>      Version 
                      For Spigot: Use Minecraft version number (eg 1.10.2) or 'latest'
                      For BungeeCord: Use BungeeCord build number (eg 1208) or 'latest'
                      For BuildTools: This doesn't apply
    -a                Apply the operation to all servers; currently unused
    -c                Don't ask for confirmation; currently unused
    -s                Stop the server if it's running before doing the operation; currently unused

###Create Arguments
    -p <port>         Server port (defaults to 25565)
    -t <type>         Server type (spigot or bungeecord, defaults to spigot)
    -b <name>         Base server; currently unused

###Start Arguments
    -f                Force startup; Kill any process using the servers port; currently unused

###Stop Arguments
    -k                Kill the server immediately; don't wait for it to stop; currently unused
    
