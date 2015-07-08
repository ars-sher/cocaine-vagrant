# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

nodes_cfg = YAML.load_file('nodes.yaml')

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
  end

  nodes_cfg.each do |node_cfg|
    config.vm.define node_cfg["name"] do |node|
      config.vm.hostname = node_cfg["name"]
      node.vm.provision "add-reverbrain-repos", type: "shell", path: "add_reverbrain_repos.sh"
      node.vm.provision "install-cocaine", type: "shell", path: "install_cocaine.sh"
      # specify config to start with in this script
      # node.vm.provision "start-cocaine", type: "shell", path: "start_cocaine.sh"
      # node.vm.provision "run-examples", type: "shell", path: "run_examples.sh"

      # node.vm.network "public_network", ip: node_cfg["ip"]  # bridged in virtualbox
      # host-only network in virtualbox. Host will be seen as 192.168.0.1 from the boxes on fresh install of VB (default vboxnet0 address is 192.168.0.1).
      # Boxes will be seen as node_cfg["ip"] from the host.
      config.vm.provider "virtualbox" do |vb|
        config.vm.network "private_network", ip: node_cfg["ip"], :name => 'vboxnet0', :adapter => 2
      end
    end
  end

  # config.vm.box = "ubuntu/trusty64"

  # config.vm.define "worker1" do |web|
  #   worker1.vm.box = "ubuntu/trusty64"
  # end

  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # config.vm.provision "cocaine", type: "shell", path: "install_cocaine.sh"
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  # config.vm.provision :shell, :path => "install_cocaine.sh"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
end
