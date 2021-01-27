#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2101

sudo printf "" # Check sudo

sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
i=1

### Download latest VSCode version ###
curl -sSL -o $HOME/Downloads/vscode.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Downloading VSCode"
  sleep 0.10
done
printf "\r  ✔ VSCode downloaded \n"


### Install the .deb ###
sudo dpkg -i $HOME/Downloads/vscode.deb >/dev/null &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Installing VSCode"
  sleep 0.10
done
printf "\r  ✔ VSCode installed \n"


### Extensions selection ###
whiptail --title "Extension instalation" --checklist --separate-output "Choose the extensions to install (cancel if you want a clean setup):" 20 78 13 \
  "Better Comments" "Customizable comments" on \
  "Bracket Pair Colorizer 2" "Colorizes each pair of brackets" on \
  "C/C++" "Language support" on \
  "GitDuck" "Collaborative code sharing" off \
  "Github Theme" "" on \
  "Indent Rainbow" "Colorizes tabs" on \
  "Java Extension Pack" "Language support" off \
  "NPM" "NPM support" on \
  "Python" "Language support" off \
  "Spanish Language Pack" "" off \
  "Visual Studio IntelliCode" "Assisted programming" on \
  "VSCode Icons" "Better icons" on 2>results

while read choice
do
  case $choice in
    "Better Comments") code --install-extension aaron-bond.better-comments
    ;;
    "Bracket Pair Colorizer 2") code --install-extension coenraads.bracket-pair-colorizer-2
    ;;
    "C/C++") code --install-extension ms-vscode.cpptools
    ;;
    "GitDuck") code --install-extension gitduck.code-streaming
    ;;
    "Github Theme") code --install-extension github.github-vscode-theme
    ;;
    "Indent Rainbow") code --install-extension oderwat.indent-rainbow
    ;;
    "Java Extension Pack") code --install-extension vscjava.vscode-java-pack
    ;;
    "NPM") code --install-extension eg2.vscode-npm-script
    ;;
    "Python") code --install-extension ms-python.python
    ;;
    "Spanish Language Pack") code --install-extension MS-CEINTL.vscode-language-pack-es
    ;;
    "Visual Studio IntelliCode") code --install-extension VisualStudioExptTeam.vscodeintellicode
    ;;
    "VSCode Icons") code --install-extension eg2.vscode-npm-script
    ;;
    *)
    ;;
  esac
done < results >/dev/null 2>&1 & 
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Installing Extensions"
  sleep 0.10
done
rm results
printf "\r  ✔ Extensions installed \n"
