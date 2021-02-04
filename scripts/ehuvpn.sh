#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2101

sudo -v # Check sudo

### Download the file from EHU's servers ###
curl -sSL -o $HOME/Downloads/ehuvpn.tar.gz https://www.ehu.eus/documents/1870470/8671861/anyconnect-linux64-4.9.04053-predeploy-k9.tar.gz/4dd385f3-b0e9-e4bd-368b-5af2f5ebdb93?t=1608209263523 & PID=$!
LOAD_MESSAGE="Downloading VPN"
COMPLETE_MESSAGE="VPN downloaded"
show_load

### Uncompressing ###
rm -r $HOME/Downloads/ehuvpn 2> /dev/null
mkdir $HOME/Downloads/ehuvpn
tar xzf $HOME/Downloads/ehuvpn.tar.gz -C $HOME/Downloads/ehuvpn & PID=$!
LOAD_MESSAGE="Extracting VPN"
COMPLETE_MESSAGE="VPN extracted"
show_load


### Start installing VPN ###
printf "\r  ${sp:i++%${#sp}:1} Installing VPN"
cd $HOME/Downloads/ehuvpn/$(ls $HOME/Downloads/ehuvpn | grep anyconnect)/vpn/
#* Okay, the installer normally asks you for a `y` during the instalation process to accept the license,
#* which is located at the license.txt file. However, if you delete this file the installer simply decides
#* not to show you the license an install the software. So we show the license with whiptail and later delete it.
if (whiptail --scrolltext --title "Do you accept the terms in the license agreement?" --yesno "$(cat license.txt)" 20 78); then
    rm license.txt # That way it does not have to accept the license
    sudo ./vpn_install.sh > /dev/null & PID=$!
    LOAD_MESSAGE="Installing VPN"
    COMPLETE_MESSAGE="VPN installed"
    show_load
else
    printf "\r  $bad VPN not installed \n"
    exit
fi
cd
printf "\r$spaces\e[0;94m${sp:i++%${#sp}:1}\e[0;0m Credential configuration"
sleep 0.1 # Just for cleanes


### Include credentials ###
if (whiptail --title "Credentials configuration" --yesno "Do you want to preconfigure the credentials and create the aliases?\nTake in mind that the credentials will be saved as environment variables, consider that on your threat model." 10 78); then
    touch .profile
    touch .bash_aliases
    printf '\n%s' '# Comandos para conectarse a la VPN de UPV' >> $HOME/.bash_aliases
    printf "\n%s" "alias ehuvpn='printf \"%s\n%s\n\" \$EHUuser \$EHUpass | /opt/cisco/anyconnect/bin/vpn -s connect vpn.ehu.es'" >> .bash_aliases
    printf "\n%s\n" "alias ehuvpnd='/opt/cisco/anyconnect/bin/vpn disconnect'" >> $HOME/.bash_aliases
    
    USER=$(whiptail --inputbox "Introduce your EHU LDAP:" 8 39 --title "User configuration" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        printf "\n%s" "export EHUuser=\"$USER\"" >> $HOME/.profile
    fi
    PASSWORD=$(whiptail --passwordbox "Please, introduce your password:" 8 78 --title "Password configuration" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        printf "\n%s" "export EHUpass=\"$PASSWORD\"" >> $HOME/.profile
    fi
    . ~/.profile
    . ~/.bash_aliases
    printf "\r  $ok Credential configuration \n"
else
    printf "\r  $bad Credential configuration \n"
fi

