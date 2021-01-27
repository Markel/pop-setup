#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2101

sudo printf "" # Check sudo

sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
i=1

sudo apt-get install nodejs -y > /dev/null &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Installing NodeJS"
  sleep 0.10
done
printf "\r  ✔ NodeJS installed \n"

sudo apt-get install npm -y > /dev/null &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Installing NPM"
  sleep 0.10
done
printf "\r  ✔ NPM installed \n"

if (whiptail --title "Gitduck console Instalation" --yesno "Do you want to install the Gitduck console package from npm?" 10 78); then
  sudo npm install --global gitduck > /dev/null 2>&1 3>&1 &
  PID=$!
  while [ -d /proc/$PID ]
  do
    printf "\r  ${sp:i++%${#sp}:1} Installing Gitduck console"
    sleep 0.10
  done
  printf "\r  ✔ Gitduck console installed \n"
else
  printf "\r  x Gitduck console not installed \n"
fi
