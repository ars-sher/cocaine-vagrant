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
sudo sh -c 'echo "export LC_ALL=\"en_US.UTF-8\"" >> /etc/environment'
source /etc/environment

echo "*** Installing git and dev things... ***"
sudo apt-get install git
sudo aptitude install -y equivs devscripts
sudo aptitude install -y python-pip python-dev

echo "*** Cloning repository with cocaine-runtime server... ***"
mkdir -p /home/vagrant/cocaine-core
git clone https://github.com/cocaine/cocaine-core.git -b v0.11 /home/vagrant/cocaine-core
cd /home/vagrant/cocaine-core
echo "*** git submodule update --init ***"
git submodule update --init

echo "*** Cloning repository with cocaine-tools ***"
mkdir -p /home/vagrant/cocaine-tools
git clone https://github.com/cocaine/cocaine-tools.git -b v0.11 /home/vagrant/cocaine-tools

echo "*** Cloning repositories with frameworks ***"
mkdir -p /home/vagrant/cocaine-framework-python && mkdir -p /home/vagrant/cocaine-framework-java
git clone https://github.com/cocaine/cocaine-framework-python.git -b v0.11 /home/vagrant/cocaine-framework-python
git clone https://github.com/cocaine/cocaine-framework-java.git /home/vagrant/cocaine-framework-java

echo "*** cocaine-runtime mk-build-deps ***"
cd /home/vagrant/cocaine-core/
sudo mk-build-deps -ir

packages_dir="/vagrant/packages"
mkdir -p "$packages_dir"

if test "$(ls -A "$packages_dir")"; then
    echo "*** $packages_dir is not empty, installing packages packages from it ***"
    cd "$packages_dir"
else
    echo "*** $packages_dir is empty, building cocaine-core from a scratch ***"
    echo "*** Building and packaging cocaine-runtime ***"
    sudo debuild -sa -us -uc
    cd ..
    cp *.deb /vagrant/packages/
fi

echo "*** Installing cocaine-runtime ***"
sudo dpkg -i cocaine-dbg_*_amd64.deb cocaine-runtime_*_amd64.deb libcocaine-core2_*_amd64.deb libcocaine-dev_*_amd64.deb

echo "*** Installing Docker ***"
curl -s https://get.docker.io/ubuntu/ | sudo sh

echo "*** Installing cocaine-tools ***"
cd /home/vagrant/cocaine-tools/
sudo python setup.py install

echo "*** Installing python framework ***"
cd /home/vagrant/cocaine-framework-python
sudo python setup.py install

echo "*** Installing elliptics ***"
ELLIPTICS_VERSION=2.26.5.4
sudo apt-get install -y elliptics="${ELLIPTICS_VERSION}" elliptics-client="${ELLIPTICS_VERSION}" libcocaine-plugin-elliptics="${ELLIPTICS_VERSION}"
mkdir -p /opt/elliptics/history.2 && chmod 777 /opt/elliptics/history.2
mkdir -p /opt/elliptics/eblob.2/ && chmod 777 /opt/elliptics/eblob.2/
mkdir -p /opt/elliptics/eblob.2/data

# pass all multicast traffic through eth1
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev eth1