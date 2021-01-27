#!/bin/bash
#! LOADING=INTEGRATED
#! SUDO=DOLLAR
#! SNAP=FALSE
#! DATE=2101

sudo printf "" # Check sudo

sp="/-\|"
i=1

### Download the file from EHU's servers ###
curl -sSL -o $HOME/Downloads/ehuvpn.tar.gz https://www.ehu.eus/documents/1870470/8671861/anyconnect-linux64-4.9.04053-predeploy-k9.tar.gz/4dd385f3-b0e9-e4bd-368b-5af2f5ebdb93?t=1608209263523 &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  [${sp:i++%${#sp}:1}] Downloading file"
  sleep 0.10
done
printf "\r  [✔] File downloaded \n"

### Uncompressing ###
rm -r $HOME/Downloads/ehuvpn 2> /dev/null
mkdir $HOME/Downloads/ehuvpn
tar xzf $HOME/Downloads/ehuvpn.tar.gz -C $HOME/Downloads/ehuvpn &
PID=$!
while [ -d /proc/$PID ]
do
  printf "\r  [${sp:i++%${#sp}:1}] Extracting file"
  sleep 0.10
done
printf "\r  [✔] File extracted \n"


### Start installing VPN ###
printf "\r  [${sp:i++%${#sp}:1}] Installing VPN"
cd $HOME/Downloads/ehuvpn/$(ls $HOME/Downloads/ehuvpn | grep anyconnect)/vpn/
if (whiptail --scrolltext --title "Do you accept the terms in the license agreement?" --yesno "$(cat license.txt)" 20 78); then
    rm license.txt # That way it does not have to accept the license
    sudo ./vpn_install.sh > /dev/null &
    while [ -d /proc/$PID ]
    do
        printf "\r  [${sp:i++%${#sp}:1}] Installing VPN"
        sleep 0.10
    done
else
    printf "\r  [x] VPN not installed \n"
    exit
fi
cd
printf "\r  [✔] VPN installed \n"
printf "\r  [${sp:i++%${#sp}:1}] Credential configuration"
sleep 0.1 # Just for cleanes


### Include credentials ###
if (whiptail --title "Credentials configuration" --yesno "Do you want to preconfigure the credentials and create the aliases?\nTake in mind that the credentials will be saved as environment variables, consider that on your threat model." 10 78); then
    touch .profile
    touch .bash_aliases
    printf '\n%s' '# Comandos para conectarse a la VPN de UPV' >> .bash_aliases
    printf "\n%s" "alias ehuvpn='printf \"%s\n%s\n\" \$EHUuser \$EHUpass | /opt/cisco/anyconnect/bin/vpn -s connect vpn.ehu.es'" >> .bash_aliases
    printf "\n%s\n" "alias ehuvpnd='/opt/cisco/anyconnect/bin/vpn disconnect'" >> .bash_aliases
    
    USER=$(whiptail --inputbox "Introduce your EHU LDAP:" 8 39 --title "User configuration" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        printf "\n%s" "export EHUuser=\"$USER\"" >> .profile
    fi
    PASSWORD=$(whiptail --passwordbox "Please, introduce your password:" 8 78 --title "Password configuration" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        printf "\n%s" "export EHUuser=\"$PASSWORD\"" >> .profile
    fi
    printf "\r  [✔] Credential configuration \n"
else
    printf "\r  [x] Credential configuration \n"
fi

