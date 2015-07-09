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
    git clone --depth=50 --branch=nightly --recursive https://github.com/3Hren/cocaine-core.git ~/cocaine/cocaine-core
    cd ~/cocaine/cocaine-core
    sudo mk-build-deps -ir
    sudo debuild -sa -us -uc
    cd .. && mv *.deb "$core_packages"
fi
cd "$core_packages" && sudo dpkg -i *.deb || true
sudo apt-get install -f
sudo dpkg -i *.deb

echo "*** Installing blackhole... ***"
blackhole_packages="$packages_dir/blackhole"
mkdir -p "$blackhole_packages"
if test "$(ls -A "$blackhole_packages")"; then
    echo "*** $blackhole_packages is not empty, installing packages from it ***"
else
    echo "*** $blackhole_packages is empty, building blackhole from a scratch ***"
    git clone --depth=50 --branch=master --recursive https://github.com/3Hren/blackhole.git ~/blackhole
    cd ~/blackhole
    sudo mk-build-deps -ir
    yes | sudo debuild -sa -us -uc
    cd .. && mv *.deb "$blackhole_packages"
fi
cd "$blackhole_packages" && sudo dpkg -i *.deb || true
sudo apt-get install -f
sudo dpkg -i *.deb

echo "*** Installing native framework... ***"
native_framework_packages="$packages_dir/cocaine-framework-native"
mkdir -p "$native_framework_packages"
if test "$(ls -A "$native_framework_packages")"; then
    echo "*** $blackhole_packages is not empty, installing packages from it ***"
else
    git clone --depth=50 --branch=master --recursive https://github.com/cocaine/cocaine-framework-native.git ~/cocaine/cocaine-framework-native
    cd ~/cocaine/cocaine-framework-native
    sudo mk-build-deps -ir
    yes | sudo debuild -sa -us -uc
    cd .. && mv *.deb "$native_framework_packages"
fi
cd "$native_framework_packages" && sudo dpkg -i *.deb || true
sudo apt-get install -f
sudo dpkg -i *.deb

echo "*** Installing python framework... ***"
sudo pip install git+https://github.com/cocaine/cocaine-framework-python.git@master

echo "*** Installing cocaine-tools... ***"
sudo pip install git+https://github.com/cocaine/cocaine-tools.git@master

echo "*** Installing cocaine plugins... ***"
sudo apt-get install libswarm2=0.6.5.1 libswarm2-xml=0.6.5.1 libswarm2-urlfetcher=0.6.5.1 #TODO
sudo apt-get install libswarm-dev=0.6.5.1
plugin_packages="$packages_dir/cocaine-plugins"
mkdir -p "$plugin_packages"
if test "$(ls -A "$plugin_packages")"; then
    echo "*** $plugin_packages is not empty, installing packages from it ***"
else
    echo "*** $plugin_packages is empty, building cocaine-plugins from a scratch ***"
    git clone --depth=50 --branch=v0.12-bleeding-edge --recursive https://github.com/cocaine/cocaine-plugins.git ~/cocaine/cocaine-plugins
    cd ~/cocaine/cocaine-plugins
    sudo mk-build-deps -ir
    sudo debuild -sa -us -uc
    cd .. && mv *.deb "$plugin_packages"
fi
cd "$plugin_packages"
echo "*** Installing Docker and it's plugin...***"
curl -s https://get.docker.io/ubuntu/ | sudo sh
sudo dpkg -i libcocaine-plugin-docker3_*_amd64.deb
echo "*** Installing IPVS plugin...***"
sudo dpkg -i libcocaine-plugin-ipvs3_*_amd64.deb || true
sudo apt-get install -f
sudo dpkg -i libcocaine-plugin-ipvs3_*_amd64.deb

echo "*** install mongodb plugin ***"
echo "*** TODO: Ask Anton about java framework, it has no 0.12 version and should not work ***"

# echo "*** Installing elliptics ***"
# ELLIPTICS_VERSION=2.26.5.4
# sudo apt-get install -y elliptics="${ELLIPTICS_VERSION}" elliptics-client="${ELLIPTICS_VERSION}" libcocaine-plugin-elliptics="${ELLIPTICS_VERSION}"
# mkdir -p /opt/elliptics/history.2 && chmod 777 /opt/elliptics/history.2
# mkdir -p /opt/elliptics/eblob.2/ && chmod 777 /opt/elliptics/eblob.2/
# mkdir -p /opt/elliptics/eblob.2/data

# pass all multicast traffic through eth1
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev eth1
