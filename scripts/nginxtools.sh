#!/bin/bash

CONF_ROOT=/etc/nginx/
SITES_ROOT=/etc/nginx/
WWW_ROOT=/var/www/
LOG_ROOT=/var/log/nginx/
CONF_DIR=/usr/local/etc/nginxtools/
ROOT_UID=0

PUB_DIR=public/
IPV=6
PORT=80
KEEPALIVE=5
PERMISSIONS=2775
CHOWNUSER=root:wwweditors

# Definitely gotta have NGINX...
command -v nginx >/dev/null || { 
    # Gotta do a backup test for installations that don't
    # link a binary the normal way
    command -v /usr/sbin/nginx >/dev/null || {
        # Okay we definitely don't have NGINX
        echo "NGINX is required.  Please install it."; exit 1;
    }
}

command -v git >/dev/null || { 
    while true; do
    read -p "Git is optional, but highly recommended.  Continue? [Y/n] " yn
    case $yn in
        [Yy]*   ) break;;
        [Nn]*   ) exit 1;;
        *       ) "Err...what?  Please enter Y or n.";;
    esac
    done
}

# Oh yeah, we're gonna need root for this...
if [[ $EUID -ne  "0" ]]
then
    echo "I'm terribly sorry...you're not running as a root user."
    exit 1
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
        echo "Site $SITENAME already exists!  Remove it if you would like to re-initialize it."; exit 1;
    fi
    echo "Creating site..."
    sudo mkdir $WWW_ROOT$SITENAME
    sudo mkdir $WWW_ROOT$SITENAME"/"$PUB_DIR
    sudo touch $WWW_ROOT$SITENAME"/"$PUB_DIR"index.html"
    echo "<html>Site created!</html>" > $WWW_ROOT$SITENAME"/"$PUB_DIR"index.html"

    if [ ! -d $CONF_ROOT"sites-available" ] || [ ! -d $CONF_ROOT"sites-enabled" ]
    then
        echo "Creating site directories..."
        sudo mkdir -p $CONF_ROOT"sites-available"
        sudo mkdir -p $CONF_ROOT"sites-enabled"
    fi

    if [ ! -d $LOG_ROOT$SITENAME ]
    then
        mkdir $LOG_ROOT$SITENAME
    else
        echo "Skipping log directory creation..."
    fi

    # Build our config file
    echo "Building configuration..."
    SITE=$CONF_ROOT"sites-available/"$SITENAME".conf"
    echo -e "server {" >> $SITE
    if [ $IPV == 6 ]
    then
        echo -e "\tlisten [::]:$PORT;" >> $SITE
    else
        echo -e "\tlisten $PORT;" >> $SITE
    fi
    
    echo -e "\tserver_name $SITENAME www.$SITENAME;" >> $SITE
    echo -e "\troot $WWW_ROOT$SITENAME/public;" >> $SITE
    echo -e "" >> $SITE
    echo -e "\taccess_log "$LOG_ROOT$SITENAME"/access.log;" >> $SITE
    echo -e "\terror_log "$LOG_ROOT$SITENAME"/error.log info;" >> $SITE
    echo -e "" >> $SITE
    echo -e "\tkeepalive_timeout "$KEEPALIVE";" >> $SITE
    echo -e "}" >> $SITE

    echo "Activating site..."
    sudo ln -s $CONF_ROOT"sites-available/"$SITENAME".conf" $CONF_ROOT"sites-enabled/"$SITENAME".conf"

    if [[ ! $@ =~ "nogit" ]]
    then
        echo "Initializing git repository..."
        cd $WWW_ROOT$SITENAME
        git init >/dev/null
        git add -A >/dev/null
    else
        echo "Skipping git repository..."
    fi

    echo "Setting permissions..."
    sudo chmod $PERMISSIONS -R $WWW_ROOT$SITENAME
    sudo chmod $PERMISSIONS -R $CONF_ROOT"sites-available"
    sudo chmod $PERMISSIONS -R $CONF_ROOT"sites-enabled"
    sudo chown -R $CHOWNUSER $WWW_ROOT$SITENAME
    sudo chown -R $CHOWNUSER $CONF_ROOT"sites-available"
    sudo chown -R $CHOWNUSER $CONF_ROOT"sites-enabled"

    echo "Reloading NGINX..."
    kill -HUP `cat /var/run/nginx.pid`

    echo ""
    echo "Your site was successfully created!  Let's have a round of applause for all the work you did."
    if [[ ! $@ =~ "nogit" ]]
    then
        echo ""
        echo "Please be advised that while your git repository has been created, nothing has been committed yet.  You'll definitely want to get some content in there and commit straightaway."
    fi
}

remove () {
    SITENAME=$2
    if [ -d $WWW_ROOT$SITENAME ]
    then
        while true; do
        read -p "About to remove virtual configuration.  This WILL delete site content directory!  Continue? [Y/n] " yn
        case $yn in
            [Yy]*    ) break;;
            [Nn]*    ) exit 1;;
             *       ) "Err...what?  Please enter Y or n.";;
        esac
        done

        sudo rm -r $WWW_ROOT$SITENAME
        echo "Removing $SITENAME...";
    else
        echo "Site $SITENAME does not exist.  Removal failed."
        exit 1;
    fi


    if [ -f $CONF_ROOT"sites-enabled/"$SITENAME".conf" ]
    then
        echo "Disabling site..."
        sudo rm $CONF_ROOT"sites-enabled/"$SITENAME".conf"
    fi

    if [ -f $CONF_ROOT"sites-available/"$SITENAME".conf" ]
    then
        echo "Removing base configuration..."
        sudo rm $CONF_ROOT"sites-available/"$SITENAME".conf"
    fi

    if [ -d $LOG_ROOT$SITENAME ] && [[ ! $@ =~ "skiplogs" ]]
    then
        echo "Removing site logs..."
        sudo rm -r $LOG_ROOT$SITENAME
    else
        echo "Skipping log removal..."
    fi

    echo "Reloading NGINX..."
    kill -HUP `cat /var/run/nginx.pid` 
}

init "$@"

exit 0
