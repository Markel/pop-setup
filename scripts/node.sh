#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2101

sudo -v # Check sudo

sudo apt-get install nodejs -y > /dev/null & PID=$!
LOAD_MESSAGE="Installing NodeJS"
COMPLETE_MESSAGE="NodeJS installed"
show_load

sudo apt-get install npm -y > /dev/null & PID=$!
LOAD_MESSAGE="Installing NPM"
COMPLETE_MESSAGE="NPM installed"
show_load

if (whiptail --title "Gitduck console Instalation" --yesno "Do you want to install the Gitduck console package from npm?" 10 78); then
  sudo npm install --global gitduck > /dev/null 2>&1 3>&1 & PID=$!
  LOAD_MESSAGE="Installing Gitduck console"
  COMPLETE_MESSAGE="Gitduck console installed"
  show_load
else
  printf "\r  $bad Gitduck console not installed \n"
fi
