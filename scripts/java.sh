#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=TRUE
#! DATE=2101

sudo -v # Check sudo

sudo apt-get install default-jdk -y > /dev/null & PID=$!
LOAD_MESSAGE="Installing Java Development Environment"
COMPLETE_MESSAGE="Java Development Environment installed"
show_load

if (whiptail --title "Eclipse Instalation" --yesno "Do you want to install Eclipse from the snap store?" 10 78); then
  sudo snap install eclipse --edge --classic > /dev/null 2>&1 3>&1 & PID=$!
  LOAD_MESSAGE="Installing Eclipse"
  COMPLETE_MESSAGE="Eclipse installed"
  show_load
else
  printf "\r  $bad Eclipse not installed      \n"
fi
