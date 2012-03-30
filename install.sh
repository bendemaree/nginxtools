#!/bin/bash

if [[ $EUID -ne "0" ]]
then
        echo "You are not running as root.  You will be prompted for your password."
fi

echo "Beginning install..."
wget https://raw.github.com/bendemaree/nginxtools/master/scripts/nginxtools.sh
echo ""

echo "Moving scripts into place..."
sudo mv nginxtools.sh /usr/local/bin/nginxtool

echo "Setting permissions..."
sudo chmod +x /usr/local/bin/nginxtool

echo "Verifying installation..."
command -v nginxtool >/dev/null || {
        echo "Installation failed...perhaps /usr/bin/local is not included in your PATH variable."
        exit 1
}

echo "Installation complete!  You are now able to use nginxtool."
rm install.sh
exit 0
