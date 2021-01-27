#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=TRUE
#! DATE=2101

sudo printf "" # Check sudo

sp="/-\|"
i=1

sudo apt-get install default-jdk -y > /dev/null &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  [${sp:i++%${#sp}:1}] Installing Java Development Environment"
  sleep 0.10
done
printf "\r  [✔] Java Development Environment installed \n"

printf "\r  [${sp:i++%${#sp}:1}] Installing Eclipse"
sleep 0.1 # Just for cleanes

if (whiptail --title "Eclipse Instalation" --yesno "Do you want to install Eclipse from the snap store?" 10 78); then
  sudo snap install eclipse --edge --classic > /dev/null &
  PID=$!
  while [ -d /proc/$PID ]
  do
    printf "\r  [${sp:i++%${#sp}:1}] Installing Eclipse"
    sleep 0.10
  done
  printf "\r  [✔] Eclipse installed \n"
else
  printf "\r  [x] Eclipse not installed \n"
fi
