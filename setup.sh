#!/bin/bash

sudo printf "\n" # Set a sudo state for the session

sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
i=1

sudo apt-get update > /dev/null && sudo apt-get upgrade > /dev/null &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r${sp:i++%${#sp}:1} Preparations: Updating and upgrading system"
  sleep 0.10
done
sleep 0.15
printf "\r"

### Extensions selection ###
whiptail --title "Markel Ferro's Setup" --checklist --separate-output "Choose with the space bar the snippets to execute:" 20 78 13 \
  "EHU VPN" "\`ehuvpn\` will connect to EHU's VPN with your LDAP" off \
  "Java Dev" "Install JDK + Eclipse (optional)" off \
  "LateX" "Use TeXlive with TeXstudio" on \
  "Node+NPM" "JS suite + Gitduck console (optional)" on \
  "VSCode" "Install VSCode with a selection of plugins" on 2>selection
  
while read choice
do
  case $choice in
    "EHU VPN")
      printf "\rEHU VPN\n "
      curl -sSL setup.markel.dev/scripts/ehuvpn.sh | bash -
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
      printf "\r✔ LateX                                             \n" # Oh shells...
    ;;
    "Node+NPM")
      printf "\rJavascript Development Environment\n "
      curl -sSL setup.markel.dev/scripts/node.sh | bash -
    ;;
    "VSCode")
      printf "\rVisual Studio Code\n "
      curl -sSL setup.markel.dev/scripts/vscode.sh | bash -
    ;;
    *)
    ;;
  esac
done < selection

rm selection
