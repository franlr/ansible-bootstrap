# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.define :node do |node|
    node.vm.box = "debian/jessie64"
    node.ssh.insert_key = false
    
    node.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    
    node.vm.network :private_network, ip: "192.168.0.11"
    node.vm.provision :shell, inline: "echo provisioning base package set to make this machine useable"

    node.vm.provision "shell" do |s|
      s.inline = "apt-get update; apt-get install -y python-software-properties ansible;"
      s.inline = "ansible-galaxy install -f -p=./roles -r playbooks/requirements.yml"
      s.privileged = true
    end
    
    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "./playbooks/setup.yml"
      ansible.inventory_path = "./inventories/hosts"
      ansible.host_key_checking = false
      ansible.limit = "all"
      ansible.sudo = true
      ansible.extra_vars = {
        ansible_ssh_user: 'vagrant',
  #      ansible_ssh_private_key_file: "~/.vagrant.d/insecure_private_key"
      }
    end
  end
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  
#  config.ssh.private_key_path = "~/.vagrant.d/insecure_private_key"
end
