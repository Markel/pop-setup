#!/bin/sh
#! LOADING=EXTERNAL
#! SUDO=DOLLAR
#! DATE=2101

sudo printf "" # Check sudo

sudo add-apt-repository ppa:sunderme/texstudio -y > /dev/null
sudo apt install texlive-full texstudio -y > /dev/null

