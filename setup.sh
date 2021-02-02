#!/bin/bash

sudo printf "\n" # Set a sudo state for the session

sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
i=1
export ok="\e[1;32m✔\e[0;0m"
export bad="\e[0;31m✘\e[0;0m"

sudo apt-get update > /dev/null && sudo apt-get upgrade > /dev/null &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r${sp:i++%${#sp}:1} Preparations: Updating and upgrading system"
  sleep 0.10
done
sleep 0.15
printf "\r$ok System updated and upgraded                   \n"

### Extensions selection ###
whiptail --title "Markel Ferro's Setup" --checklist --separate-output "Choose with the space bar the snippets to execute:" 20 78 13 \
  "EHU VPN" "\`ehuvpn\` will connect to EHU's VPN with your LDAP" off \
  "EHU SSH" "\`ehush\` will connect to EHU's SSH" off \
  "Java Dev" "Install JDK + Eclipse (optional)" off \
  "Mathematica" "Download and install from EHU's servers" off \
  "LateX" "Use TeXlive with TeXstudio" on \
  "Node+NPM" "JS suite + Gitduck console (optional)" on \
  "Program bundle" "Install multiple programs" on \
  "VSCode" "Install VSCode with a selection of plugins" on 2>selection

### SNAP SUPPORT ###
while read choice
do
  case $choice in
  "Java Dev" | "Program bundle")
    sudo apt-get install snapd -y > /dev/null &
    PID=$!
    while [ -d /proc/$PID ]
    do
      printf "\r${sp:i++%${#sp}:1} Installing snap (requirement)"
      sleep 0.10
    done;
    printf "\r$ok Snap installed (requirement) \n"
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
    "EHU VPN")
      printf "\rEHU VPN\n "
      curl -sSL setup.markel.dev/scripts/ehuvpn.sh | bash -
    ;;
    "EHU SSH")
      ### Download latest VSCode version ###
      curl -sSL setup.markel.dev/scripts/ehussh.sh | bash - &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r${sp:i++%${#sp}:1} Setting up the SSH"
        sleep 0.10
      done
      printf "\r$ok SSH Configuration                                \n" # Oh shells...
    ;;
    "Java Dev") 
      printf "\rJava Development Environment\n "
      curl -sSL setup.markel.dev/scripts/java.sh | bash -
    ;;
    "LateX")
      ### Download latest VSCode version ###
      curl -sSL setup.markel.dev/scripts/latex.sh | bash - &
      PID=$!
      while [ -d /proc/$PID ]
      do
        printf "\r${sp:i++%${#sp}:1} Downloading LateX (this may take a while...)"
        sleep 0.10
      done
      printf "\r$ok LateX                                             \n" # Oh shells...
    ;;
    "Mathematica")
      printf "\rMathematica\n "
      curl -sSL setup.markel.dev/scripts/ehumathematica.sh | bash -
    ;;
    "Node+NPM")
      printf "\rJavascript Development Environment\n "
      curl -sSL setup.markel.dev/scripts/node.sh | bash -
    ;;
    "Program bundle")
      printf "\rProgram bundle\n "
      curl -sSL setup.markel.dev/scripts/bundle.sh | bash -
    ;;
    "VSCode")
      printf "\rVisual Studio Code\n "
      curl -sSL setup.markel.dev/scripts/vscode.sh | bash -
    ;;
    *)
    ;;
  esac
done < selection

rm selection > /dev/null 2>&1 3>&1 && sudo apt-get -f install -y > /dev/null 2>&1 3>&1 && sleep 0.75 && killall -3 gnome-shell > /dev/null 2>&1 3>&1 && sleep 0.1 & # The sleeps are so the user doesn't scare
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r${sp:i++%${#sp}:1} Finishing: You will experience visual glitches. Relax 😎"
  sleep 0.10
done
printf "\r$ok Finished 🥳                                              \n"

printf "\nThe setup process has finished, you may check the results above. Please check that everything was installed correctly. It is also recommended to reboot the computer to apply some changes, although it is not strictly necessary.\nEnjoy your day and DFTBA.\n"