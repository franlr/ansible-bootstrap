#!/bin/sh

# Requires epel repo enabled
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
#
# From centos repositories or from yum.puppetlabs.com:
yum install-y facter

yum install -y python-devel python-setuptools
# yum install -y python-paramiko PyYAML python-jinja2
yum --enablerepo=epel* install -y ansible sshpass gmp python-pip python-six
# centos 6.5 msg:
# [WARNING]: The version of gmp you have installed has a known issue regarding
# timing vulnerabilities when used with pycrypto. If possible, you should update
# it (i.e. yum update gmp).
# https://github.com/ualbertalib/Developer-Handbook/tree/master/Ansible
yum --enablerepo=epel* install -y gmp-devel asciidoc
# recommended: yum install -y openssh-clients
#
#
# or installed from source
#
#
yum groupinstall -y 'Development Tools'
cd /opt
git clone git://github.com/ansible/ansible.git
cd /opt/ansible
make rpm
rpm -Uvh ~/rpm-build/ansible-*.noarch.rpm

export ANSIBLE_HOSTS=/etc/ansible/hosts
