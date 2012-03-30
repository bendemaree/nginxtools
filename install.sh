#!/bin/bash

echo ""
echo ""

echo "Beginning install..."
wget -quiet https://raw.github.com/bendemaree/nginxtools/master/scripts/nginxtools.sh >/dev/null
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
exit 0
