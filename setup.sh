#!/bin/bash

if [[ $(uname -n) != "pop-os" ]]
then
  printf "⚠️ This script is thought for Pop-OS, it may work in similar systems, but you are warned if it doesn't.\n"
fi

### SUDO LEVELS ###
if [[ $EUID -eq 0 ]]
then
  printf "Please run the script as normal user.\n" >&2
  exit 1
fi

sudo -p "Become Super 🚀 with your password: " printf "\n" || exit 1 # Set a sudo state for the session

#* Sudo restart
mkdir $HOME/Documents/SetupInstaller/ > /dev/null 2>&1 3>&1
rm $HOME/Documents/SetupInstaller/INSTALL_FINISHED > /dev/null 2>&1 3>&1

#* Maintain sudo for all the sesion https://unix.stackexchange.com/a/261110 (modified version)
while [ ! -f "$HOME/Documents/SetupInstaller/INSTALL_FINISHED" ]; do
  sleep 60 # Check every minute for sudo
  sudo -v
done &

### OFFLINE MODE ###
if [ -f "setup.sh" ]; then
  printf "🗀 \"Offline\" mode activated\n"
  offline=true
else
  # printf "🌐 Online mode activated\n"
  offline=false
fi

### GLOBAL VARIABLES ###
show_load() {
  while [ -d /proc/$PID ]
  do
    printf "\r$spaces\e[0;94m${sp:i++%${#sp}:1}\e[0;0m $LOAD_MESSAGE"
    sleep 0.10
  done
  ceol=$(tput el)
  printf "\r${ceol}$spaces$ok $COMPLETE_MESSAGE\n"
}

i=1
export sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
export spaces=""
export ok="\e[1;32m✔\e[0;0m"
export bad="\e[0;31m✘\e[0;0m"
export -f show_load

### PREREQUISITES ###
if [ "$offline" != true ] ; then
  sudo apt-get update > /dev/null && sudo apt-get upgrade -y --allow-downgrades > /dev/null & PID=$!
  LOAD_MESSAGE="Preparations: Updating and upgrading system"
  COMPLETE_MESSAGE="System updated and upgraded"
  show_load
fi

### Obtain some download links ###
  # Last updated: 03/2021. New link at: https://download.kde.org/stable/digikam/
  export digikamURL="https://download.kde.org/stable/digikam/7.2.0/digiKam-7.2.0-x86-64.appimage"
  # Last updated: 03/2021. New link at: https://www.ehu.eus/eu/web/ikt-tic/vpn
  export EHUVPNURL="https://www.ehu.eus/documents/1870470/8671861/anyconnect-linux64-4.9.04053-predeploy-k9.tar.gz/4dd385f3-b0e9-e4bd-368b-5af2f5ebdb93?t=1608209263523"
  # Last updated: 03/2021. New link at: https://www.ehu.eus/liz/m4s/mathematica_for_students/
  export mathematicaPingURL="https://www.ehu.eus/liz/m4s/mathematica_for_students/v12.1.1/"
  export mathematicaDownloadURL="https://www.ehu.eus/liz/m4s/mathematica_for_students/v12.1.1/Mathematica_12.1.1_LINUX.iso"
  # Last updated: 03/2021. New link at: https://www.danieltufvesson.com/makeresolvedeb
  export resolveddebURL="https://www.danieltufvesson.com/download/?file=makeresolvedeb/makeresolvedeb_1.4.5_multi.sh.tar.gz"
  # Last updated: 03/2021. New link at: https://www.veracrypt.fr/en/Downloads.html
  export veracryptURL="https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-Ubuntu-20.10-amd64.deb"
  # Last updated: 03/2021. New link (it should auto update)
  export VSCodeURL="https://update.code.visualstudio.com/latest/linux-deb-x64/stable"

echo $digikamURL

### Extensions selection ###
whiptail --title "Markel Ferro's Setup" --checklist --separate-output "Choose with the space bar the snippets to execute (B is beta):" 20 78 13 \
  "Power" "Open power settings to configure screens" on \
  "EHU VPN" "\`ehuvpn\` will connect to EHU's VPN with your LDAP" off \
  "EHU SSH" "\`ehush\` will connect to EHU's SSH" off \
  "Java Dev" "Install JDK + Eclipse (optional)" off \
  "LateX" "Use TeXlive with TeXstudio" on \
  "Mathematica" "Download and install from EHU's servers" off \
  "Node+NPM" "JS suite + Gitduck console (optional)" on \
  "Program bundle" "Install multiple programs" on \
  "Resolve" "Install Blackmagic's DaVinci Resolve (B)" off \
  "VSCode" "Install VSCode with a selection of plugins" on 2>selection

### SNAP SUPPORT ###
while read choice
do
  case $choice in
  "Java Dev" | "Program bundle")
    sudo apt-get install snapd -y > /dev/null & PID=$!
    LOAD_MESSAGE="Installing snap (requirement)"
    COMPLETE_MESSAGE="Snap installed (requirement)"
    show_load
    break
  ;;
  esac
done < selection

### COMMANDS ###
while read choice
do
  case $choice in
    # "Automatic login")
    #   sudo sed -i 's/#  AutomaticLoginEnable = true/AutomaticLoginEnable = true/' /etc/gdm3/custom.conf &&
    #   sudo sed -i "s/#  AutomaticLogin = user1/AutomaticLogin = $USER/" /etc/gdm3/custom.conf & #* The double quotes allow $USER to expand
    #   PID=$!
    #   while [ -d /proc/$PID ]
    #   do
    #     printf "\r${sp:i++%${#sp}:1} Setting automatic login for $USER"
    #     sleep 0.10
    #   done
    #   printf "\r$ok Automatic login set for $USER          \n"
    # ;;
    "Power")
      gnome-control-center power > /dev/null 2>&1 3>&1 & PID=$!
      LOAD_MESSAGE="Waiting power settings to be closed"
      COMPLETE_MESSAGE="Power settings configured"
      show_load
    ;;
    "EHU VPN")
      printf "\rEHU VPN\n "
      spaces="  "
      if [ "$offline" = true ] ; then
        ./scripts/ehuvpn.sh
      else
        curl -sSL setup.markel.dev/scripts/ehuvpn.sh | bash -
      fi
    ;;
    "EHU SSH")
      printf "\r\e[0;94m${sp:i++%${#sp}:1}\e[0;0m Setting up the SSH"
      if [ "$offline" = true ] ; then
        ./scripts/ehussh.sh
      else
        curl -sSL setup.markel.dev/scripts/ehussh.sh | bash - 
      fi
      ceol=$(tput el)
      printf "\r${ceol}$spaces$ok SSH Configuration\n"
    ;;
    "Java Dev") 
      printf "\rJava Development Environment\n "
      spaces="  "
      if [ "$offline" = true ] ; then
        ./scripts/java.sh
      else
        curl -sSL setup.markel.dev/scripts/java.sh | bash -
      fi
    ;;
    "LateX")
      spaces=""
      if [ "$offline" = true ] ; then
        ./scripts/latex.sh
      else
        curl -sSL setup.markel.dev/scripts/latex.sh | bash - 
      fi & PID=$!
      LOAD_MESSAGE="Downloading LateX (this may take a while...)"
      COMPLETE_MESSAGE="LateX"
      show_load
    ;;
    "Mathematica")
      printf "\rMathematica\n "
      spaces="  "
      if [ "$offline" = true ] ; then
        ./scripts/ehumathematica.sh
      else
        curl -sSL setup.markel.dev/scripts/ehumathematica.sh | bash -
      fi
    ;;
    "Node+NPM")
      printf "\rJavascript Development Environment\n "
      spaces="  "
      if [ "$offline" = true ] ; then
        ./scripts/node.sh
      else
        curl -sSL setup.markel.dev/scripts/node.sh | bash -
      fi
    ;;
    "Program bundle")
      printf "\rProgram bundle\n "
      spaces="  "
      if [ "$offline" = true ] ; then
        ./scripts/bundle.sh
      else
        curl -sSL setup.markel.dev/scripts/bundle.sh | bash -
      fi
    ;;
    "Resolve")
      printf "\rDaVinci Resolve\n "
      spaces="  "
      if [ "$offline" = true ] ; then
        ./scripts/resolve.sh
      else
        curl -sSL setup.markel.dev/scripts/resolve.sh | bash -
      fi
    ;;
    "VSCode")
      printf "\rVisual Studio Code\n "
      spaces="  "
      if [ "$offline" = true ] ; then
        ./scripts/vscode.sh
      else
        curl -sSL setup.markel.dev/scripts/vscode.sh | bash -
      fi
    ;;
    *)
    ;;
  esac
done < selection

spaces=""
# sleep 0.75 && killall -3 gnome-shell > /dev/null 2>&1 3>&1
rm selection > /dev/null 2>&1 3>&1 && sudo apt-get -f install -y > /dev/null 2>&1 3>&1 && touch $HOME/Documents/SetupInstaller/INSTALL_FINISHED && sleep 0.1 & # The sleeps are so the user doesn't scare
PID=$!
LOAD_MESSAGE="Finishing: Relax 😎"
COMPLETE_MESSAGE="Finished 🥳"
show_load

printf "\nThe setup process has finished, you may check the results above. Please check that everything was installed correctly. It is also recommended to reboot the computer to apply some changes, although it is not strictly necessary.\nEnjoy your day and DFTBA.\n"
