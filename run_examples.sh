#!/bin/bash

set -e

echo "*** Removing old entries, if any... ***"
cocaine-tool app stop --name "echo-app" || true
cocaine-tool app stop --name qr || true
cocaine-tool app stop --name "echo-docker" || true
cocaine-tool app remove --name "echo-app" || true
cocaine-tool app remove --name qr || true
cocaine-tool app remove --name "echo-docker" || true
cocaine-tool profile remove --name process-example
cocaine-tool profile remove --name docker-example

echo "*** Uploading profiles... ***"
cocaine-tool profile upload --name process-example --profile /vagrant/cocaine-profiles/process-profile.json
cocaine-tool profile upload --name docker-example --profile /vagrant/cocaine-profiles/docker-profile.json

echo "*** Uploading apps... ***"
cd /vagrant/app-examples/echo
cocaine-tool app upload --name "echo-app"
# cd /vagrant/app-examples/docker/ TODO: do not forget DOCKER_OPTS="$DOCKER_OPTS --insecure-registry=192.168.0.2:5000" in /etc/default/docker
# sudo cocaine-tool app upload --docker-address=unix:///var/run/docker.sock --registry=192.168.0.2:5000 --manifest manifest.json --name echo-docker
cd /vagrant/app-examples/qr
cocaine-tool app upload --name qr

echo "*** Starting apps... ***"
cocaine-tool app start -n "echo-app" --profile process-example
# cocaine-tool app start --name echo-docker --profile docker-example

cocaine-tool app check -n "echo-app" || true
cocaine-tool app check -n qr || true
cocaine-tool app check -n "echo-docker" || true