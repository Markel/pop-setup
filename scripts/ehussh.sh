#!/bin/bash
#! LOADING=EXTERNAL
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2103

# Note, this is not a secure ssh connection, just so you know.

sudo -v # Check sudo

sudo apt-get install sshpass sshfs -y > /dev/null

SERVER="dif-linuxserver.ehu.es"

SERVER=$(whiptail --inputbox "Introduce your SSH server:" 8 39 dif-linuxserver.ehu.es --title "User configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus != 0 ]; then
  printf "$bad SSH not installed"
  exit
fi

USER=$(whiptail --inputbox "Introduce your SSH user:" 8 39 --title "User configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
  printf "\n%s" "export EHUsshuser=\"$USER\"" >> $HOME/.profile
else
  printf "$bad SSH not installed"
  exit
fi

PASSWORD=$(whiptail --passwordbox "Please, introduce your password:" 8 78 --title "Password configuration" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
  printf "\n%s" "export EHUsshpass=\"$PASSWORD\"" >> $HOME/.profile
else
  printf "$bad SSH not installed"
  exit
fi

printf '\n%s' '# Comandos para el servidor linux de la uni' >> $HOME/.bash_aliases
printf "\n%s" "alias ehush='sshpass -p \"\$EHUsshpass\" ssh -o \"StrictHostKeyChecking no\" $SERVER -l \$EHUsshuser'" >> $HOME/.bash_aliases
printf "\n%s\n" "alias vpnsh='ehuvpn && ehush'" >> $HOME/.bash_aliases

if (whiptail --title "Mounting point" --yesno "Do you want to create a command for mounting the SSH server?" 8 78); then
  LOCALMOUNT="$HOME/Documents/remoteSSH/"
  REMOTEMOUNT="/users/alumnos/acaf/$USER/"
  
  LOCALMOUNT=$(whiptail --inputbox "Select a folder in your local computer in which to mount the SSH server (it must be a folder with regular rwe permissions):" 10 78 "$LOCALMOUNT" --title "Local mounting point:" 3>&1 1>&2 2>&3)
  mkdir $LOCALMOUNT > /dev/null 2>&1 3>&1
  REMOTEMOUNT=$(whiptail --inputbox "Select the folder to mount from the remote computer (it must be a folder with regular rwe permissions):" 10 78 "$REMOTEMOUNT" --title "Remote mounting point:" 3>&1 1>&2 2>&3)
  
  printf "%s\n" "alias moush='echo \$EHUsshpass | sshfs -o password_stdin \$EHUsshuser@$SERVER:$REMOTEMOUNT $LOCALMOUNT'" >> $HOME/.bash_aliases
  printf "%s\n\n" "alias umoush='umount $LOCALMOUNT'" >> $HOME/.bash_aliases
fi
