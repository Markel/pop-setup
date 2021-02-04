#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2102
#! STATE=BETA

sudo -v # Check sudo

sp="⠙⠸⠼⠴⠦⠧⠇⠏⠋"
i=1

ZIPNAME="foo"

show_zip_waiting() {
  if (whiptail --title "Download Davinci Resolve" --yesno "Please download the zip for linux from Blackmagic's official website (blackmagicdesign.com/products/davinciresolve/) an place it on Downloads (note: only one file in Downloads should have the name \"Resolve\"). Once done it press Yes. If you want to install Resolve later press No to stop the script." 12 78) then
    ZIPNAME=$(ls $HOME/Downloads | grep Resolve)
  else
    printf "\r  $bad Resolve not installed (manual stop) \n"
    exit
  fi
}


### The "Download" process ###
#* Blackmagic doesn't provide a link perse, so you need to download it manually as you have to fill a form to download the file
# TODO: Investigate if with some POSTs we could auto-download Resolve
if [ $(ls $HOME/Downloads | grep Resolve | wc -l) != "1" ]; then
  while [ $(ls $HOME/Downloads | grep Resolve | wc -l) != "1" ]; do
    show_zip_waiting
    sleep 0.05 #* So it seems like something happened
  done
else
  if (whiptail --title "Previous Resolve Download" --yesno "Do you want to use the $(ls $HOME/Downloads | grep Resolve) file located in Downloads? Selecting no will stop the instalation; restart the script after deleting that file or replacing it with the correct one. (Note: only one file in Downloads should have the name \"Resolve\")" 10 78) then
    ZIPNAME=$(ls $HOME/Downloads | grep Resolve)
    printf "\r  $ok Using the previous download\n"
  else
    printf "\r  $bad Resolve not installed (restart with the correct file) \n"
    exit
  fi
fi

### Download ResolveDeb ###
#* Just to be sure with grep instead of naming it MakeResolveDeb I named it MakeResolvDeb
curl -sSL -o $HOME/Downloads/MakeResolvDeb.sh.tar.gz https://www.danieltufvesson.com/download/?file=makeresolvedeb/makeresolvedeb_1.4.4_multi.sh.tar.gz &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Downloading MakeResolveDeb"
  sleep 0.10
done
printf "\r  $ok MakeResolveDeb downloaded  \n"

### Install dependencies and upzip them ###
cd $HOME/Downloads
sudo apt-get install xorriso libssl1.1 ocl-icd-opencl-dev fakeroot -y > /dev/null && tar -xf $HOME/Downloads/MakeResolvDeb.sh.tar.gz -C $HOME/Downloads && unzip $HOME/Downloads/$ZIPNAME -d $HOME/Downloads > /dev/null &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Getting things ready"
  sleep 0.10
done
printf "\r  $ok Things ready             \n"


### Creating the .deb ###
#RESOLVER=$(whiptail --title "Program instalation" --radiolist "Choose the programs to install:" 20 35 13 "lite" "The free one" on "studio" "The paid one" off 3>&1 1>&2 2>&3)

RESOLVERNAME="$(ls $HOME/Downloads | grep makeresolvedeb)"

./$RESOLVERNAME $(ls $HOME/Downloads | grep DaVinci_Resolve*.run) > resolver_output.txt &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Creating a Resolve installer"
  sleep 0.10
done
printf "\r  $ok Resolve installer created     \n"


### Installing the .deb ###
DEBNAME="$(ls $HOME/Downloads | grep davinci*.deb)"

sudo dpkg -i $HOME/Downloads/$DEBNAME > dpkg_output.txt &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  ${sp:i++%${#sp}:1} Installing Resolve"
  sleep 0.10
done
printf "\r  $ok Resolve installed     \n"

cd