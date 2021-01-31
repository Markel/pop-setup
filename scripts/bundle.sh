#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=TRUE
#! DATE=2101

sudo printf "" # Check sudo

sudo apt-get install snapd -y > /dev/null

sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
i=1

whiptail --title "Program instalation" --checklist --separate-output "Choose the programs to install:" 20 78 13 \
  "Authy" "2FA Code manager" on \
  "GIMP" "GNU Image manipulation program" on \
  "gThumb" "A better image viewer" on \
  "Inkscape" "Vector graphics editor" off \
  "OBS" "Open Broadcaster Software" on \
  "Pomodoro" "Get things done by taking short breaks" on \
  "Sublime Merge" "Git Client, done Sublime" on \
  "Syncthing" "Continuous file synchronization program" on \
  "Veracrypt" "Disk encryption" on 2>programs

while read choice
do
  case $choice in
    "Authy")
      sudo snap install authy --beta > /dev/null 2>&1 3>&1 &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing Authy"
        sleep 0.10
      done
      printf "\r  ✔ Authy installed \n"
    ;;
    "GIMP")
      sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y > /dev/null 2>&1 3>&1 && sudo apt install gimp -y > /dev/null &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing GIMP"
        sleep 0.10
      done
      printf "\r  ✔ GIMP installed \n"
    ;;
    "gThumb")
      sudo add-apt-repository ppa:dhor/myway -y > /dev/null 2>&1 3>&1 && sudo apt-get install gthumb -y > /dev/null &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing gThumb"
        sleep 0.10
      done
      printf "\r  ✔ gThumb installed \n"
      sudo add-apt-repository --remove ppa:dhor/myway -y > /dev/null 2>&1 3>&1 # I don't like this repository too much
    ;;
    "Inkscape")
      sudo apt-get install inkscape -y > /dev/null &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing Inkscape"
        sleep 0.10
      done
      printf "\r  ✔ Inkscape installed \n"
    ;;
    "OBS") 
      sudo add-apt-repository ppa:obsproject/obs-studio -y > /dev/null 2>&1 3>&1 && sudo apt-get install ffmpeg obs-studio -y > /dev/null &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing OBS"
        sleep 0.10
      done
      printf "\r  ✔ OBS installed \n"
    ;;
    "Pomodoro")
      sudo apt-get install gnome-shell-pomodoro -y > /dev/null &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing Pomodoro"
        sleep 0.10
      done
      printf "\r  ✔ Pomodoro installed \n"
    ;;
    "Sublime Merge")
      sudo snap install sublime-merge --classic > /dev/null 2>&1 3>&1 &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing Sublime Merge"
        sleep 0.10
      done
      printf "\r  ✔ Sublime Merge installed \n"
    ;;
    "Syncthing")
      sudo apt-get install apt-transport-https syncthing -y > /dev/null &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing Syncthing"
        sleep 0.10
      done
      printf "\r  ✔ Syncthing installed (configuration needed) \n"
    ;;
    "Veracrypt")
      curl -sSL -o $HOME/Downloads/veracrypt.deb https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-Ubuntu-20.10-amd64.deb && 
      sudo dpkg -i $HOME/Downloads/vscode.deb >/dev/null &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r  ${sp:i++%${#sp}:1} Installing Veracrypt"
        sleep 0.10
      done
      printf "\r  ✔ Veracrypt installed \n"
    ;;
    *)
    ;;
  esac
done < programs

rm programs
