#!/bin/sh

# Resume: ansible 1.9.x 'master'
# Host: Debian 8 "Jessie" (64 bits)
# Guest: Ubuntu 14.04 "Trusty" (64 bits)
# Tags: debian, virtualbox, vagrant, ansible, ubuntu

# Enable debian 8 contrib repo
sudo cat >>/etc/apt/sources.list<<EOF

# Debian 8 "Jessie"
deb http://http.debian.net/debian/ jessie main contrib
EOF
sudo apt-get update

# VirtualBox 4.3.12
sudo apt-get install -y linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') virtualbox

# Vagrant
sudo apt-get install vagrant
mkdir -p /home/usuer/development/vagrant/01/
#vagrant box add hashicorp/precise64
#vagrant init hashicorp/precise64

vagrant box add ubuntu/trusty64
vagrant init ubuntu/trusty64
vagrant up
vagrant ssh

# Run this code into the vagrant box
sudo apt-get install -y sshpass git-core tree curl
sudo apt-get install -y python-setuptools
cd /tmp
wget http://releases.ansible.com/ansible/ansible-1.9.1.tar.gz
tar -xvf ansible-1.9.1.tar.gz
cd ansible-1.9.1/
sudo python setup.py install
sudo git clone https://github.com/franlr/ansible-box.git /etc/ansible
sudo cp /tmp/ansible-1.9.1/examples/ansible.cfg /etc/ansible/
sudo cp /tmp/ansible-1.9.1/examples/hosts /etc/ansible/

# Mod settings of ansible.cfg
sh -c 'echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config'
sed -i "s/^#remote_port$/remote_port/" /etc/ansible/ansible.cfg
sed -i "s/^#roles_path$/roles_path/"" /etc/ansible/ansible.cfg
sed -i "s/^#host_key_checking$/host_key_checking/" /etc/ansible/ansible.cfg
sed -i "s/^#remote_user$/remote_user/" /etc/ansible/ansible.cfg
sed -i "s/^#scp_if_ssh$/scp_if_ssh/" /etc/ansible/ansible.cfg
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_HOSTS=/etc/ansible/hosts

# Ansible test
ansible -i inventories/development.ini localhost -m setup
ansible -i inventories/development.ini localhost -m ping
