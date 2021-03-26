#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=TRUE
#! DATE=2103

sudo -v # Check sudo

whiptail --title "Program instalation" --checklist --separate-output "Choose the programs to install:" 20 78 13 \
  "AppImage" "AppImageLauncher integrates them to launchers" on \
  "Authy" "2FA Code manager" on \
  "GDB" "General debugging program" on \
  "GIMP" "GNU Image manipulation program" on \
  "gParted" "Disk partitioning" off \
  "gThumb" "A better image viewer" on \
  "Inkscape" "Vector graphics editor" off \
  "OBS" "Open Broadcaster Software" on \
  "Pomodoro" "Get things done by taking short breaks" on \
  "Sublime Merge" "Git Client, done Sublime" on \
  "Syncthing" "Continuous file synchronization program" on \
  "Tweaks" "Tweaking GNOME" on \
  "Veracrypt" "Disk encryption" on 2>programs

while read choice
do
  case $choice in
    "AppImage")
      sudo add-apt-repository ppa:appimagelauncher-team/stable -y > /dev/null 2>&1 3>&1 && sudo apt-get install appimagelauncher -y > /dev/null & PID=$!
      LOAD_MESSAGE="Installing AppImageLauncher"
      COMPLETE_MESSAGE="AppImageLauncher installed"
      show_load;
    ;;
    "Authy")
      sudo snap install authy --beta > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing Authy"
      COMPLETE_MESSAGE="Authy installed"
      show_load;
    ;;
    "GDB")
      sudo apt-get install gdb -y > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing GDB"
      COMPLETE_MESSAGE="GDB installed"
      show_load;
    ;;
    "GIMP")
      sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y > /dev/null 2>&1 3>&1 && sudo apt-get install gimp -y > /dev/null & PID=$!
      LOAD_MESSAGE="Installing GIMP"
      COMPLETE_MESSAGE="GIMP installed"
      show_load;
    ;;
    "gParted")
      sudo apt-get install gparted -y > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing gParted"
      COMPLETE_MESSAGE="gParted installed"
      show_load;
    ;;
    "gThumb")
      sudo add-apt-repository ppa:dhor/myway -y > /dev/null 2>&1 3>&1 && sudo apt-get install gthumb -y > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing gThumb"
      COMPLETE_MESSAGE="gThumb installed"
      show_load
      sudo add-apt-repository --remove ppa:dhor/myway -y > /dev/null 2>&1 3>&1; # I don't like this repository too much
    ;;
    "Inkscape")
      sudo apt-get install inkscape -y > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing Inkscape"
      COMPLETE_MESSAGE="Inkscape installed"
      show_load;
    ;;
    "OBS") 
      sudo add-apt-repository ppa:obsproject/obs-studio -y > /dev/null 2>&1 3>&1 && sudo apt-get install ffmpeg obs-studio -y > /dev/null & PID=$!
      LOAD_MESSAGE="Installing OBS"
      COMPLETE_MESSAGE="OBS installed"
      show_load;
    ;;
    "Pomodoro")
      sudo apt-get install gnome-shell-pomodoro -y > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing Pomodoro"
      COMPLETE_MESSAGE="Pomodoro installed"
      show_load;
    ;;
    "Sublime Merge")
      sudo snap install sublime-merge --classic > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing Sublime Merge"
      COMPLETE_MESSAGE="Sublime Merge installed"
      show_load;
    ;;
    "Syncthing")
      sudo apt-get install apt-transport-https syncthing -y > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing Syncthing"
      COMPLETE_MESSAGE="Syncthing installed (configuration needed)"
      show_load;
    ;;
    "Tweaks")
      sudo apt-get install gnome-tweaks -y > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing gnome-tweaks"
      COMPLETE_MESSAGE="Gnome-tweaks installed"
      show_load;
    ;;
    "Veracrypt")
      curl -sSL -o $HOME/Downloads/veracrypt.deb https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-Ubuntu-20.10-amd64.deb && 
      sudo dpkg -i $HOME/Downloads/veracrypt.deb > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Installing Veracrypt"
      COMPLETE_MESSAGE="Veracrypt installed"
      show_load;
    ;;
    *)
    ;;
  esac
done < programs

rm programs
