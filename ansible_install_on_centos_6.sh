#!/bin/sh

# Requires epel repo enabled
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
#
# From centos repositories or from yum.puppetlabs.com:
yum install facter

yum install -y python-devel python-setuptools
yum --enablerepo=epel* install -y ansible sshpass gmp python-pip
# or installed from source
yum groupinstall -y 'Development Tools'
cd /opt
git clone git://github.com/ansible/ansible.git
cd ./ansible
make rpm
rpm -Uvh ~/rpmbuild/ansible-*.noarch.rpm

export ANSIBLE_HOSTS=/etc/ansible/hosts
