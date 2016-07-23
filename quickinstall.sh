#!/bin/bash
# Copyright 2016, jgamblin, released under the MIT License 
# See https://github.com/jgamblin/quickinstall/blob/master/LICENSE for the
# complete license text
# Source code at https://github.com/jgamblin/quickinstall

# Upgrade installed packages to latest
echo -e "\nRunning a package upgrade...\n"
apt-get -qq -y update && apt-get -qq -y dist-upgrade


#Install stuff I use all the time
echo -e "\nInstalling default packages...\n"
apt-get -qq -y install build-essential checkinstall docker.io fail2ban git git-core libbz2-dev libc6-dev libgdbm-dev libncursesw5-dev libreadline-gplv2-dev libsqlite3-dev libssl-dev nikto nmap nodejs python-dev python-numpy python-scipy python-setuptools tk-dev unattended-upgrades ufw


#Install and configure firewall
echo -e "\nConfiguring firewall...\n"
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh

sed -i.bak 's/ENABLED=no/ENABLED=yes/g' /etc/ufw/ufw.conf
chmod 0644 /etc/ufw/ufw.conf

# set timezone to UTC
echo -e "\nUpdating Timezone to UTC...\n"
sudo timedatectl set-timezone UTC

#Install Ruby
echo -e "\nInstalling Ruby...\n"
curl -L https://get.rvm.io | bash -s stable --ruby

#PCAP Everything
echo -e "\nRunning docker: pcap...\n"
docker run -v ~/pcap:/pcap --net=host -d jgamblin/tcpdump

#Add unprivileged user account
echo -e "\nAdding unpriviliged user\n"
useradd ashumate
mkdir -p /home/ashumate/.ssh/
cat "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMcsKIY7QfLFSGMNwLdVzk2/5CYPTaR2nO8pqdr0uKNIZxrXCt3r84RfIcq2sb6IMyHa7oUUth3gqYnQFGdMvINubENkdgsCTLFjzAe8kpMtzDBvlaQtFfeGY6/X/O5JXjrbc90viMdzHDqmArAplIRIlPQGDFwKGqv+MWvPihCrn2IZLXIco78IF+pgDjCcOJur6dIS1MQvbicoaJhZpIB/Oa1zqsCYeDpc3jj7FusmL3ml+8OTg5WmgUJ1GWcX4xsYndIn6TIN+OcqsN/w5kD7f51QiQxOpgVwxF329amxOcreEcBHVPeexV59boEKD6dPLbuXwWe9YyK6ZGXEwUOCax1azz6uXgMPwuQkEe8en3rvkp6kWXVZJk9Xaxw0TNnx2OT/ibzlRMiaoNqhl7qAU/uVSJ+91Mcp3dN3kVuYUnIwYja33sP2SzFNeED0zcX0rHrvbuM/Q/u+QZQ1vPDuhBpURmXb0zfZA7Z1QSPRvuqbPuDEf3rnkY7wEDqty7/JFRAAbnkWobGIwADMjTHYLWL28OCdPjnZ7b6s3V0h6bOl2L1kn/qhkgLTvVvQW9utEOFlxSZZkaYtUijmdRh5m651mTDvGOB0QTQbRbrmfMtVTQuXdpH68kwtTyH412VsTiB1+JjQ9Af7/kiTdJg9vf1Kpyv/QEroJimPkt2w== ashumate@gmail.com" > /home/ashumate/.ssh/authorized_keys

#Reboot server
reboot now
