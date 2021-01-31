#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2101


#! This scripts is untested (due to the long times of downloading and installing, so bear that in mind)

# NOTE: This script only works if you are a student from UPV/EHU as it uses its servers to download the Mathematica ISO, however, if you place a
# ISO in your downloads folder it should work with it (take care that it must be the one with the MathInstaller script)

sudo printf "" # Check sudo

sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
i=1
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
    printf "\r  $bad Mathematica not downloaded nor installed. Error code: $(curl -o /dev/null --user $EHUuser:$EHUpass -s -w "%{http_code}\n" https://www.ehu.eus/liz/m4s/mathematica_for_students/v12.1.1/) \n"
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
    while [ $(curl -o /dev/null --user $EHUuser:$EHUpass -s -w "%{http_code}\n" https://www.ehu.eus/liz/m4s/mathematica_for_students/v12.1.1/) != "200" ]
    do
      login_info
    done
    printf "\r  $ok Logged in to EHU's servers     \n"
    curl -sSL -C - -o $HOME/Downloads/Mathematica.iso --user $EHUuser:$EHUpass https://www.ehu.eus/liz/m4s/mathematica_for_students/v12.1.1/Mathematica_12.1.1_LINUX.iso &
    PID=$!
    while [ -d /proc/$PID ]
    do
      printf "\r  ${sp:i++%${#sp}:1} Downloading Mathematica (this may take a while...)"
      sleep 0.10
    done
    printf "\r  $ok Mathematica downloaded                                 \n"
  fi
else
  #* Download the ISO as no is present (from 0)
  printf "\r  ${sp:i++%${#sp}:1} Logging in to EHU's servers"
  while [ $(curl -o /dev/null --user $EHUuser:$EHUpass -s -w "%{http_code}\n" https://www.ehu.eus/liz/m4s/mathematica_for_students/v12.1.1/) != "200" ]
  do
    login_info
  done
  printf "\r  $ok Logged in to EHU's servers    \n"
  curl -sSL -o $HOME/Downloads/Mathematica.iso --user $EHUuser:$EHUpass https://www.ehu.eus/liz/m4s/mathematica_for_students/v12.1.1/Mathematica_12.1.1_LINUX.iso &
  PID=$!
  while [ -d /proc/$PID ]
  do
    printf "\r  ${sp:i++%${#sp}:1} Downloading Mathematica (this may take a while...)"
    sleep 0.10
  done
  printf "\r  $ok Mathematica downloaded                                 \n"
fi


### MOUNT ###
sudo umount /mnt/iso > /dev/null 2>&1 3>&1
sudo mkdir /mnt/iso > /dev/null 2>&1
sudo mount -o loop "$HOME/Downloads/$ISONAME" /mnt/iso > /dev/null 2>&1 3>&1 &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Mounting instalation media"
  sleep 0.10
done
printf "\r  $ok Instalation media mounted   \n"

### INSTALL ###
sudo /mnt/iso/Unix/Installer/MathInstaller -auto -silent &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Installing Mathematica (this may take a while...)"
  sleep 0.10
done
printf "\r  $ok Mathematica installed                                   \n"
