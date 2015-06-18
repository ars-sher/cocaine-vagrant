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

echo "*** Updating repositories... ***"
sudo apt-get update
echo "*** Installing git... ***"
sudo apt-get install git

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
#These repositories contain frameworks that you will use to create apps
#Python
git clone https://github.com/cocaine/cocaine-framework-python.git -b v0.11 /home/vagrant/cocaine-framework-python
#Java
git clone https://github.com/cocaine/cocaine-framework-java.git /home/vagrant/cocaine-framework-java

echo "*** Installing dev things ***"
sudo aptitude install -y equivs devscripts
sudo aptitude install -y python-pip python-dev

echo "*** cocaine-runtime mk-build-deps ***"
cd /home/vagrant/cocaine-core/
sudo mk-build-deps -ir
echo "*** Building and packaging cocaine-runtime ***"
sudo debuild -sa -us -uc
echo "*** Installing cocaine-runtime ***"
cd ..
sudo dpkg -i cocaine-dbg_*_amd64.deb cocaine-runtime_*_amd64.deb libcocaine-core2_*_amd64.deb libcocaine-dev_*_amd64.deb

echo "*** Installing Docker ***"
curl -s https://get.docker.io/ubuntu/ | sudo sh

echo "*** Installing cocaine-tools ***"
cd /home/vagrant/cocaine-tools/
sudo python setup.py install

