#!/bin/sh

echo "############# INSTALL NODEJS #############"

curl -sL https://deb.nodesource.com/setup_${NODE_BRANCH} | bash -
apt-get update
apt-get install -y --no-install-recommends nodejs npm
npm install -g npm
apt-get clean
rm -rf /var/lib/apt/lists/