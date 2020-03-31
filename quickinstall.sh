#!/bin/bash
# Copyright 2016, jgamblin, released under the MIT License 
# See https://github.com/jgamblin/quickinstall/blob/master/LICENSE for the
# complete license text
# Source code at https://github.com/jgamblin/quickinstall
# This is my version (Andrew Shumate)

# Upgrade installed packages to latest
echo -e "\nRunning a package upgrade...\n"
debian_frontend=noninteractive
apt-get -qq -y update && apt-get -qq -y dist-upgrade

#Add logon banner
echo -e '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n'>/etc/issue.net
echo -e "       AAA   TTTTTTT TTTTTTT EEEEEEE NN   NN TTTTTTT IIIII  OOOOO  NN   NN">>/etc/issue.net
echo -e "      AAAAA    TTT     TTT   EE      NNN  NN   TTT    III  OO   OO NNN  NN">>/etc/issue.net
echo -e "     AA   AA   TTT     TTT   EEEEE   NN N NN   TTT    III  OO   OO NN N NN">>/etc/issue.net
echo -e "     AAAAAAA   TTT     TTT   EE      NN  NNN   TTT    III  OO   OO NN  NNN">>/etc/issue.net
echo -e "     AA   AA   TTT     TTT   EEEEEEE NN   NN   TTT   IIIII  OOOOO  NN   NN\n">>/etc/issue.net
echo -e "         If you're not expected then you're not invited so fuck off"'! \n'>>/etc/issue.net
echo -e "             This is a private system and all access attempts">>/etc/issue.net
echo -e "                 will be logged for appropriate action.\n\n">>/etc/issue.net
echo -e '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'>>/etc/issue.net

#Install stuff I use all the time
echo -e "\nInstalling default packages...\n"
apt-get -qq -y install fail2ban git git-core ufw

#Install MSF
#curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
#  chmod 755 msfinstall && \
#  ./msfinstall

#Install and configure firewall
echo -e "\nConfiguring firewall...\n"
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https

sed -i.bak 's/ENABLED=no/ENABLED=yes/g' /etc/ufw/ufw.conf
chmod 0644 /etc/ufw/ufw.conf

# set timezone to UTC
echo -e "\nUpdating Timezone to UTC...\n"
sudo timedatectl set-timezone UTC

#Install Ruby
#echo -e "\nInstalling Ruby...\n"
#curl -L https://get.rvm.io | bash -s stable --ruby

#PCAP Everything
#echo -e "\nRunning docker: pcap...\n"
#docker run -v ~/pcap:/pcap --net=host -d jgamblin/tcpdump

#Add admin group
echo -e "\nAdding Admin group\n"
groupadd admin

#Add unprivileged user account
echo -e "\nAdding unpriviliged user\n"
useradd -m -G admin -s /bin/bash ashumate

#Add .ssh directory and change ownership/permisions then add ssh key
echo -e "\nAdding SSH key\n"
mkdir -p /home/ashumate/.ssh/
chown ashumate:admin /home/ashumate/.ssh/
chmod 700 /home/ashumate/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2pyyeH437qzQ9H0zkjpDdYBT6B9+67OBppnFQ+qIGh ashumate@Andrews-MacBook-Pro.local" > /home/ashumate/.ssh/authorized_keys

#Reboot server
reboot now
