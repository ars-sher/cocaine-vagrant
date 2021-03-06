#!/bin/bash

set -e

# echo "*** Starting elliptics at port 1025 ***"
# dnet_ioserv -c /vagrant/elliptics-conf/ioserv-default.json&
# if [ $? -eq 0 ]; then
# 	echo "*** Elliptics started succefully ***"
# fi
# disown
# sleep 10

sudo mkdir -p /var/run/cocaine
sudo mkdir -p /var/lib/cocaine/runlists/
sudo touch /var/lib/cocaine/runlists/default
sudo chown -R cocaine /var/lib/cocaine/
sudo chown -R cocaine /var/run/cocaine
echo "*** Starting cocaine ***"
sudo service cocaine-v12-runtime stop
sudo sh -c 'cat > /etc/default/cocaine-runtime <<EOF
CONFIG_PATH="/vagrant/cocaine-conf/cocaine-local.conf"
RUNTIME_PATH="/var/run/cocaine"
EOF'
# sudo sh -c 'cat > /etc/default/cocaine-runtime <<EOF
# CONFIG_PATH="/vagrant/cocaine-conf/cocaine-elliptics.conf"
# RUNTIME_PATH="/var/run/cocaine"
# EOF'

sudo service cocaine-runtime start
#sudo cocaine-runtime -c /vagrant/cocaine-conf/cocaine-local.conf -d
echo "*** Cocaine service started, look for logs in /var/log/syslog! ***"