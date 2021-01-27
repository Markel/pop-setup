#!/bin/bash
#! LOADING=EXTERNAL
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2101

sudo printf "" # Check sudo

sudo apt-get install sshpass -y > /dev/null

SERVER="dif-linuxserver.ehu.es"

SERVER=$(whiptail --inputbox "Introduce your SSH user:" 8 39 dif-linuxserver.ehu.es --title "User configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus != 0 ]; then
  printf "✘ SSH not installed"
  exit
fi

USER=$(whiptail --inputbox "Introduce your SSH user:" 8 39 --title "User configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
  printf "\n%s" "export EHUsshuser=\"$USER\"" >> $HOME/.profile
fi

PASSWORD=$(whiptail --passwordbox "Please, introduce your password:" 8 78 --title "Password configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
  printf "\n%s" "export EHUsshpass=\"$PASSWORD\"" >> $HOME/.profile
fi

printf '\n%s' '# Comandos para el servidor linux de la uni' >> $HOME/.bash_aliases
printf "\n%s" "alias ehush='sshpass -p \"\$EHUsshpass\" ssh $SERVER -l \$EHUsshuser'" >> $HOME/.bash_aliases
printf "\n%s\n" "alias vpnsh='ehuvpn && ehush'" >> $HOME/.bash_aliases

. ~/.profile
. ~/.bash_aliases
#alias ehus='sshpass -p "$EHUsshpass" ssh dif-linuxserver.ehu.es -l $EHUsshuser'
#alias vpnsh='ehuvpn && ehus'
