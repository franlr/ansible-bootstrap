#!/bin/sh

# Install and configure Facter (PuppetLabs) and Ansible on Debian 7 ("Wheezy")
# Python > 2.6 installed
export PATH=$PATH:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/opt/local/bin

export CODENAME=`lsb_release -c | awk '{print $2}'`
export FACTER_VERSION="2.3.0"
export SUFFIX="1puppetlabs1"
export TAG="1.9.0-1"
export RELEASE="unstable"
export CONFDIR="/etc/ansible"
filepath=`pwd`

# Ensure that this script is run by root
if [ $(id -u) -ne 0 ]; then
sudo $0
exit
fi

# mkdir new directory if it doesn't exist
testmkdir() {
if [ ! -d $1 ]; then
mkdir -p $1
fi
}

testmkdir "/root/software"

# Requirements and utilities
apt-get install -y build-essential lsb-release
apt-get install -y make fakeroot cdbs debhelper dpkg-dev
apt-get install -y wget curl libcurl3 libcurl3-dev vim tree less git-core openssl

## Facter (2.3.0)
wget -O /root/software/puppetlabs-release-$CODENAME.deb http://apt.puppetlabs.com/puppetlabs-release-$CODENAME.deb
dpkg -i /root/software/puppetlabs-release-$CODENAME.deb
apt-get update
apt-get install -y facter=$FACTER_VERSION-$SUFFIX
rm -f /root/software/puppetlabs-release-$CODENAME.deb

# Ansible installation

## Install from repositories (1.7.2)
# apt-get install -y -t wheezy-backports ansible

apt-get update
apt-get install -y python-pip python-paramiko python-yaml python-jinja2 python-httplib2 \
python-setuptools python-dev python-all-dev python-support python-pkg-resources \
python-crypto python-markupsafe sshpass

git clone -b v$TAG https://github.com/ansible/ansible.git /opt/ansible --recursive
cd /opt/ansible
# method 1
# source ./hacking/env-setup -q
## or method 2
# make install
## or method 3
apt-get install -y make fakeroot cdbs debhelper dpkg-dev 
make deb
dpkg -i ./deb-build/unstable/ansible*.deb
## or method 4
# easy_install pip
# pip install paramiko PyYAML Jinja2 httplib2

echo "***************************************************************"
echo "version facter `facter -v`"
echo "`ansible --version`"
echo "***************************************************************"

# Ansible configuration
testmkdir $CONFDIR
testmkdir $CONFDIR/{roles,library,group_vars,host_vars,filter_plugins}

# ansible.cfg
# takes the last ansible.cfg from the installed release
# http://docs.ansible.com/intro_configuration.html

cp /opt/ansible/examples/ansible.cfg $CONFDIR/

sh -c 'echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config'
sed -i "s/^#remote_port$/remote_port/" /etc/ansible/ansible.cfg
sed -i "s/^#roles_path$/roles_path/"" /etc/ansible/ansible.cfg
sed -i "s/^#host_key_checking$/host_key_checking/" /etc/ansible/ansible.cfg
sed -i "s/^#remote_user$/remote_user/" /etc/ansible/ansible.cfg
sed -i "s/^#scp_if_ssh$/scp_if_ssh/" /etc/ansible/ansible.cfg

# Hosts
cp $filepath/hosts $CONFDIR/

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_HOSTS=/etc/ansible/hosts

# Testing...
# ansible all -inventory-file=/etc/ansible/hosts -m ping
