#!/bin/bash

set -e

sudo service cocaine-runtime stop
sudo sh -c 'cat > /etc/default/cocaine-runtime <<EOF
CONFIG_PATH="/vagrant/cocaine-conf/cocaine-local.conf"
RUNTIME_PATH="/var/run/cocaine"
EOF'

sudo service cocaine-runtime start
#sudo cocaine-runtime -c /vagrant/cocaine-conf/cocaine-local.conf -d
echo "*** Cocaine service started, look for logs in /var/log/syslog! ***"