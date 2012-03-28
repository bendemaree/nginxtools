#!/bin/sh

CONF_ROOT=/etc/nginx/conf/
SITES_ROOT=/etc/nginx/conf/
WWW_ROOT=/var/www/
CONF_DIR=/usr/local/etc/nginxtools/
IPV=6

ROOT_UID=0

# Definitely gotta have NGINX...
command -v nginx >/dev/null && continue || { echo "NGINX is required.  Please install it."; exit 1; }

# Oh yeah, we're gonna need root for this...
if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "I'm terribly sorry...you're not running as a root user."
fi

# Interpret first argument
init ()
{
    case $1 in
        create      ) create "$@";;
        remove      ) remove "$@";;
        list        ) list "$@";;
    esac
}

create ()
{
    SITENAME=$2
    if [ -d $WWW_ROOT$SITENAME ]
    then
        echo "That site already exists!  Remove it if you would like to re-initialize it."; exit 1;
    fi
    sudo mkdir $WWW_ROOT$SITENAME
    sudo touch $WWW_ROOT$SITENAME"/index.html"
    echo "<html>Site created!</html>" > $WWW_ROOT$SITENAME"/index.html"
}

init "$@"
exit 0
