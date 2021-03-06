#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2103

#! This scripts are not completely tested (due to the long times of downloading and installing, but they should work)

# NOTE: This script only works if you are a student from UPV/EHU as it uses its servers to download the Mathematica ISO, however, if you place a
# ISO in your downloads folder it should work with it (take care that it must be the one with the MathInstaller script)

sudo -v # Check sudo

attempts_remain=3+1
ISONAME="Mathematica.iso"

change_credentials() {
  EHUuser=$(whiptail --inputbox "Introduce your LDAP:" 8 39 --title "User configuration" 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus != 0 ]; then
    printf "\r  $bad Mathematica not downloaded nor installed (invalid credentials) \n"
    exit
  fi

  EHUpass=$(whiptail --passwordbox "Please, introduce your password:" 8 78 --title "Password configuration" 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus != 0 ]; then
    printf "\r  $bad Mathematica not downloaded nor installed (invalid credentials) \n"
    exit
  fi
}

login_info() {
  ((attempts_remain--))
  if [ $attempts_remain -le 0 ]; then
    printf "\r  $bad Mathematica not downloaded nor installed. Error code: $(curl -o /dev/null --user $EHUuser:$EHUpass -s -w "%{http_code}\n" $mathematicaPingURL) \n"
    exit
  fi
  whiptail --title "Login to EHU/UPV" --msgbox "You must login to the UPV/EHU servers to download Mathematica. Repeated fails may represent that the 12.1.1 version is not available anymore, file a bug in that case. Login has failed $attempts_remain times." 10 78
  change_credentials
}


### DOWNLOAD ###
if [ $(ls $HOME/Downloads | grep Mathematica | wc -l) = "1" ]; then
  ##* A previous Mathematica ISO is there
  if (whiptail --title "Previous Mathematica Download" --yesno "Do you want to use the $(ls $HOME/Downloads | grep Mathematica) located in Downloads? Only select yes if you are sure that it is a not corrupted/incompleted version of Mathematica, otherwise the instalation will fail." 10 78) then
    #* Use the existing Mathematica ISO
    ISONAME=$(ls $HOME/Downloads | grep Mathematica)
    printf "\r  $bad Mathematica not downloaded (using previous download) \n"
  else
    #* Do not use the existing Mathematica ISO (finish the download)
    printf "\r  ${sp:i++%${#sp}:1} Logging in to EHU's servers"
    while [ $(curl -o /dev/null --user $EHUuser:$EHUpass -s -w "%{http_code}\n" $mathematicaPingURL) != "200" ]
    do
      login_info
    done
    printf "\r  $ok Logged in to EHU's servers     \n"
    curl -sSL -C - -o $HOME/Downloads/Mathematica.iso --user $EHUuser:$EHUpass $mathematicaDownloadURL & PID=$!
    LOAD_MESSAGE="Downloading Mathematica (this may take a while...)"
    COMPLETE_MESSAGE="Mathematica downloaded"
    show_load
  fi
else
  #* Download the ISO as no is present (from 0)
  printf "\r  ${sp:i++%${#sp}:1} Logging in to EHU's servers"
  while [ $(curl -o /dev/null --user $EHUuser:$EHUpass -s -w "%{http_code}\n" $mathematicaPingURL) != "200" ]
  do
    login_info
  done
  printf "\r  $ok Logged in to EHU's servers    \n"
  curl -sSL -o $HOME/Downloads/Mathematica.iso --user $EHUuser:$EHUpass $mathematicaDownloadURL & PID=$!
  LOAD_MESSAGE="Downloading Mathematica (this may take a while...)"
  COMPLETE_MESSAGE="Mathematica downloaded"
  show_load
fi


### MOUNT ###
sudo apt-get install p7zip-full p7zip-rar -y > /dev/null 2>&1 3>&1 &&
7z x ~/Downloads/Mathematica.iso -o$HOME/Downloads/Mathematica > /dev/null 2>&1 3>&1 & PID=$!
LOAD_MESSAGE="Extracting Mathematica"
COMPLETE_MESSAGE="Mathematica extracted"
show_load

### INSTALL ###
sudo ~/Downloads/Mathematica/Unix/Installer/MathInstaller -auto -silent & PID=$!
LOAD_MESSAGE="Installing Mathematica (this may take a while...)"
COMPLETE_MESSAGE="Mathematica installed"
show_load
