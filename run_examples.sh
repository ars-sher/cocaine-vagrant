#!/bin/bash

set -e

echo "*** Removing old apps, if any... ***"
cocaine-tool app remove --name Echo || true
cocaine-tool app remove --name QR || true
cocaine-tool app remove --name DockerEcho || true

echo "*** Uploading profiles... ***"
cocaine-tool profile upload --name process-example --profile /vagrant/cocaine-profiles/process-profile.json
cocaine-tool profile upload --name docker-example --profile /vagrant/cocaine-profiles/docker-profile.json

echo "*** Uploading apps... ***"
cd /vagrant/app-examples/echo
cocaine-tool app upload --name Echo
cd /vagrant/app-examples/docker/
cocaine-tool app upload --name DockerEcho
cd /vagrant/app-examples/qr
cocaine-tool app upload --name QR

app check -n Echo
app check -n QR
app check -n DockerEcho