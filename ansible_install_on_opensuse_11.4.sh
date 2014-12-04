#!/bin/sh

zypper install --non-interactive --no-gpg-checks git-core python-pip python-setuptools python-devel
git clone git://github.com/ansible/ansible.git --recursive /opt/ansible
cd /opt/ansible
source ./hacking/env-setup
easy_install pip
pip install paramiko PyYAML Jinja2 httplib2
mkdir -p /etc/ansible/
#
cp /opt/ansible/examples/ansible.cfg /etc/ansible/
cp /opt/ansible/examples/hosts /etc/ansible/
#nano /etc/ansible/hosts
