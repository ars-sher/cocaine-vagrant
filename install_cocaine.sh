#!/bin/bash

set -e

echo "*** System info... ***"
uname -a
lsb_release -a

# supress apt-get's questions
sudo sh -c 'cat > /etc/apt/apt.conf.d/90forceyes <<EOF
APT::Get::Assume-Yes "true";
APT::Get::force-yes "true";
EOF'

# Fix locale complains
sudo sh -c 'echo "export LC_ALL=\"en_US.UTF-8\"" >> /etc/bash.bashrc'
source /etc/bash.bashrc

echo "*** Installing git and dev things... ***"
sudo apt-get update
sudo apt-get install git
sudo aptitude install -y devscripts build-essential equivs python-software-properties
sudo aptitude install -y python-pip python-dev
sudo pip install setuptools
sudo aptitude install -y libssl-dev

# echo "*** Travis things ***"
# sudo apt-get install -y python-software-properties
# sudo apt-add-repository -y ppa:brightbox/ruby-ng
# sudo apt-get update
# sudo apt-get install ruby2.1 ruby-switch
# sudo ruby-switch --set ruby2.1
# sudo apt-get install -y ruby2.1-dev
# sudo gem install travis --no-rdoc --no-ri
# git clone https://github.com/travis-ci/travis-build.git ~/travis-build
# ln -s ~/travis-build/ ~/.travis/travis-build

echo "*** Installing cocaine... ***"
packages_dir="/vagrant/packages"
mkdir -p "$packages_dir"

echo "*** Installing cocaine core... ***"
core_packages="$packages_dir/cocaine-core"
mkdir -p "$core_packages"
if test "$(ls -A "$core_packages")"; then
    echo "*** $core_packages is not empty, installing packages from it ***"
else
    echo "*** $core_packages is empty, building cocaine-core from a scratch ***"
    git clone --depth=50 --branch=v0.12 --recursive git://github.com/cocaine/cocaine-core.git ~/cocaine/cocaine-core
    cd ~/cocaine/cocaine-core
    sudo mk-build-deps -ir
    sudo debuild -sa -us -uc
    cd .. && mv *.deb "$core_packages"
fi
cd "$core_packages" && sudo dpkg -i *.deb || true
sudo apt-get install -f

git clone --depth=50 --branch=v0.12 --recursive https://github.com/cocaine/cocaine-framework-native.git ~/cocaine/cocaine-framework-native
cd ~/cocaine/cocaine-framework-native


echo "*** Installing python framework... ***"
sudo pip install git+https://github.com/cocaine/cocaine-framework-python.git

echo "*** Installing cocaine-tools... ***"
sudo pip install git+https://github.com/cocaine/cocaine-tools.git@v0.12

echo "*** Installing cocaine plugins... ***"
sudo apt-get install libswarm2=0.6.5.1 libswarm2-xml=0.6.5.1 libswarm2-urlfetcher=0.6.5.1 #TODO
sudo apt-get install libswarm-dev=0.6.5.1
plugin_packages="$packages_dir/cocaine-plugins"
mkdir -p "$plugin_packages"
if test "$(ls -A "$plugin_packages")"; then
    echo "*** $plugin_packages is not empty, installing packages from it ***"
else
    echo "*** $plugin_packages is empty, building cocaine-plugins from a scratch ***"
    git clone --depth=50 --branch=v0.12 --recursive https://github.com/cocaine/cocaine-plugins.git ~/cocaine/cocaine-plugins
    cd ~/cocaine/cocaine-plugins
    sudo mk-build-deps -ir
    sudo debuild -sa -us -uc
    cd .. && mv *.deb "$plugin_packages"
fi
echo "*** Installing Docker and it's plugin...***"
curl -s https://get.docker.io/ubuntu/ | sudo sh
cd "$plugin_packages" && sudo dpkg -i libcocaine-plugin-docker3_*_amd64.deb 


pwd
echo "*** TODO: try to install docker plugin, https://github.com/cocaine/cocaine-plugins/tree/master/docker ***"
echo "*** TODO: try to install ipvs plugin, https://github.com/cocaine/cocaine-plugins/tree/master/ipvs ***"
echo "*** TODO: Ask Anton about java framework, it has no 0.12 version and should not work ***"

# echo "*** Cloning repository with cocaine-runtime server... ***"
# mkdir -p /home/vagrant/cocaine-core
# git clone https://github.com/cocaine/cocaine-core.git -b v0.11 /home/vagrant/cocaine-core
# cd /home/vagrant/cocaine-core
# echo "*** git submodule update --init ***"
# git submodule update --init
# echo "*** Building cocaine-runtime dependencies and installing them... ***"
# cd /home/vagrant/cocaine-core/
# sudo mk-build-deps -ir

# packages_dir="/vagrant/packages"
# mkdir -p "$packages_dir"

# if test "$(ls -A "$packages_dir")"; then
#     echo "*** $packages_dir is not empty, installing packages packages from it ***"
#     cd "$packages_dir"
# else
#     echo "*** $packages_dir is empty, building cocaine-core from a scratch ***"
#     echo "*** Building and packaging cocaine-runtime ***"
#     sudo debuild -sa -us -uc
#     cd .. && cp *.deb /vagrant/packages/
# fi

# echo "*** Installing cocaine-runtime ***"
# sudo dpkg -i cocaine-dbg_*_amd64.deb cocaine-runtime_*_amd64.deb libcocaine-core2_*_amd64.deb libcocaine-dev_*_amd64.deb

# echo "*** Cloning repository with cocaine-tools ***"
# mkdir -p /home/vagrant/cocaine-tools
# git clone https://github.com/cocaine/cocaine-tools.git -b v0.11 /home/vagrant/cocaine-tools
# echo "*** Installing cocaine-tools ***"
# cd /home/vagrant/cocaine-tools/
# sudo python setup.py install

# echo "*** Cloning repositories with frameworks ***"
# mkdir -p /home/vagrant/cocaine-framework-python && mkdir -p /home/vagrant/cocaine-framework-java
# git clone https://github.com/cocaine/cocaine-framework-python.git -b v0.11 /home/vagrant/cocaine-framework-python
# git clone https://github.com/cocaine/cocaine-framework-java.git /home/vagrant/cocaine-framework-java
# echo "*** Installing python framework ***"
# cd /home/vagrant/cocaine-framework-python
# sudo python setup.py install

# echo "*** Installing elliptics ***"
# ELLIPTICS_VERSION=2.26.5.4
# sudo apt-get install -y elliptics="${ELLIPTICS_VERSION}" elliptics-client="${ELLIPTICS_VERSION}" libcocaine-plugin-elliptics="${ELLIPTICS_VERSION}"
# mkdir -p /opt/elliptics/history.2 && chmod 777 /opt/elliptics/history.2
# mkdir -p /opt/elliptics/eblob.2/ && chmod 777 /opt/elliptics/eblob.2/
# mkdir -p /opt/elliptics/eblob.2/data

# # pass all multicast traffic through eth1
# sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev eth1
