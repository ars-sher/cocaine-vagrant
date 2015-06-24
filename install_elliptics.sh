#!/bin/bash

set -e

ELLIPTICS_VERSION=2.26.5.4

sudo apt-get install -y elliptics="${ELLIPTICS_VERSION}" elliptics-client="${ELLIPTICS_VERSION}" libcocaine-plugin-elliptics="${ELLIPTICS_VERSION}"