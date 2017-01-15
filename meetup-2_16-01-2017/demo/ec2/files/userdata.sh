#!/bin/bash
set -o nounset
set -o errexit

export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y install apache2

hostname > /var/www/html/index.html

exit 0
