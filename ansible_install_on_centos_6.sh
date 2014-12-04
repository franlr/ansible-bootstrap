#!/bin/sh

# Requires epel repo enabled
yum --enablerepo=epel* install -y ansible sshpass facter gmp python-pip
# or installed from source
yum installl -y "Development tools"
cd /opt
git clone git://github.com/ansible/ansible.git
cd ./ansible
make rpm
rpm -Uvh ~/rpmbuild/ansible-*.noarch.rpm
