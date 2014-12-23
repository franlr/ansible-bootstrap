#!/bin/sh

# Install and configure Ansible on Debian 7 (Wheezy)

# ensure that this script is run by root
if [ $(id -u) -ne 0 ]; then
sudo $0
exit
fi

# mkdir if it doesn't exist
testmkdir() {
if [ ! -d $1 ]; then
mkdir -p $1
fi
}

testmkdir "/root/software"

# Requirements
apt-get install -y build-essential git-core libssl-dev curl wget lsb-release

export CODENAME=`lsb_release -c | awk '{print $2}'`
export FACTER_VERSION="2.3.0"
export SUFFIX="1puppetlabs1"
TAG="1.8.2"

## Facter (2.3.0)
wget -O /root/software/puppetlabs-release-$CODENAME.deb /http://apt.puppetlabs.com/puppetlabs-release-$CODENAME.deb
dpkg -i /root/software/puppetlabs-release-$CODENAME.deb
apt-get update
apt-get install -y facter=$FACTER_VERSION-$SUFFIX

# Ansible installation

## Install from repositories (1.7.2)
#apt-get install -y python-setuptools python-dev python-yaml python-paramiko python-jinja2 sshpass
#apt-get install -y python-pip
#apt-get install -y -t wheezy-backports ansible

## Install from source (1.8.2)
git clone --branch v$TAG https://github.com/ansible/ansible.git /opt/ansible
apt-get install -y python-setuptools python-pip python-dev sshpass
pip install PyYAML jinja2 paramiko
cd /opt/ansible
make install

# Configuration
export ANSIBLE_HOSTS=./ansible-tools/hosts
sh -c 'echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config'

# Testing
ansible all --inventory-file=./ansible-tools/hosts -m ping
