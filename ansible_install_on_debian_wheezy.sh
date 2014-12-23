#!/bin/sh
# Ansible on Debian Wheezy

# Requirements
apt-get install -y build-essential git-core libssl-dev curl wget lsb-release

## Facter (2.3.0)
wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
dpkg -i puppetlabs-release-wheezy.deb
apt-get update
apt-get install -y facter=2.3.0-1puppetlabs1

# Installation

## Install from repositories (1.7.2)
#apt-get install -y python-setuptools python-dev python-yaml python-paramiko python-jinja2 sshpass
#apt-get install -y python-pip
#apt-get install -y -t wheezy-backports ansible

## Install from source (1.8.0)
git clone --branch v1.8.0 https://github.com/ansible/ansible.git /opt/ansible
apt-get install -y python-setuptools python-pip python-dev sshpass
pip install PyYAML jinja2 paramiko
cd /opt/ansible
make install

# Configuration
export ANSIBLE_HOSTS=./ansible-tools/hosts
sh -c 'echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config'

# Testing
ansible all --inventory-file=./ansible-tools/hosts -m ping
