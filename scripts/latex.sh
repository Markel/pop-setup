#!/bin/sh
#! LOADING=EXTERNAL
#! SUDO=DOLLAR
#! DATE=2101

sudo -v # Check sudo

sudo add-apt-repository ppa:sunderme/texstudio -y > /dev/null
sudo apt-get install texlive-full texstudio -y > /dev/null

