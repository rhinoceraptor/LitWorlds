#! /bin/bash
#########################################################
# nodejs deploy script
# Literary Worlds - CS 4900
# Jack Lewis
#########################################################

GIT_URL=https://github.com/rhinoceraptor/LitWorlds.git

set -e

apt-get -q -y install git nodejs nodejs-legacy npm

npm install -g forever coffee-script

cd ~moo
git clone ${GIT_URL}
cd LitWorlds/src/server
npm install
cake build

cd ../client
cake build

echo "done, run sudo forever start server.js to start the server\n"