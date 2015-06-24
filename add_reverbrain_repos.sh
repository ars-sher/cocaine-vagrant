#!/bin/bash

set -e

sudo sh -c 'cat > /etc/apt/sources.list.d/reverbrain.list <<EOF
deb http://repo.reverbrain.com/trusty/ current/amd64/
deb http://repo.reverbrain.com/trusty/ current/all/
EOF'

curl http://repo.reverbrain.com/REVERBRAIN.GPG | sudo apt-key add -
echo "*** Reverbrain repos added, updating repositories... ***"
sudo apt-get update