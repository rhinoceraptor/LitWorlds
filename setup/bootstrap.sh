#!/bin/sh -u

# exit if an error occurs
set -e

echo 'setup enCore server'
#########################################################
# Server deploy script from a bare debian install
# LambdaMOO and enCore db
# Literary Worlds - CS 4900
# Jack Lewis
#########################################################
# URLs for server and db
ENCORE_URL=http://downloads.sourceforge.net/project/ele/enCore%20Database/enCore%204.0.1/enCore-4.0.1.tar.gz
LAMBDA_MOO_URL=http://lingo.uib.no/v5/downloads/LambdaMOO-1.8.1-unicode.tar.gz
# Directories for installation
INSTALLDIR=/usr/local/moo
APACHEDIR=/etc/apache2
#########################################################

# install updates, sudo, apache, gcc, bison, vim non-interatively
echo 'installing sudo apache, gcc bison, vim and make'
sudo apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get -q -y install sudo apache2 gcc make bison vim csh

# create a moo user, with sudo group, 
echo 'creating a moo user'
if [ -z "$(getent passwd moo)" ]; then
    echo "user does NOT exist."
	useradd -g sudo -s /bin/bash -p users -d /home/moo -m moo
else
    echo "user ALREADY exist."
fi

# make INSTALLDIR directory
echo 'creating the install directory'
mkdir -p ${INSTALLDIR}
cd ${INSTALLDIR}

# wget both files
echo 'wget enCore and LamdaMOO'

wget ${ENCORE_URL}
wget ${LAMBDA_MOO_URL}
# untar LambdaMOO and enCore to ${INSTALLDIR}
echo 'extract both files'
tar -zxvf LambdaMOO-1.8.1-unicode.tar.gz
tar -zxvf enCore-4.0.1.tar.gz

# make src directory and move source files to src directory
echo 'creating src directory and moving source files to src directory'
cd ${INSTALLDIR}
mkdir -p src
mv -u *.tar.gz src

# compile the MOO server
echo 'compiling the MOO server'
cd ${INSTALLDIR}/MOO-1.8.1
sh configure
make

# make bin directory, copy the moo server and the restart script to it
echo 'making bin directory and coping MOO server and restart scripts to it'
cd ${INSTALLDIR}
mkdir -p bin
cp -u MOO-1.8.1/moo bin/
cp -u MOO-1.8.1/restart bin/

# go to the apache install directory and create an alias for Xpress
echo 'creating an alias for Xpress'
cd ${APACHEDIR}
echo -n "Alias /encore \"/usr/local/moo/encore\"" >> apache2.conf

# Add enCore.db, moo, and restart to the bin directory
echo 'adding enCore.db, moo and restart to the bin directory'
cd ${INSTALLDIR}/bin
cp -u ../MOO-1.8.1/moo .
cp -u ../MOO-1.8.1/restart .
cp -u ../encore/enCore.db .

# check that the bin directory has the correct contents
echo 'checking bin directory contents...'
cd ${INSTALLDIR}/bin
ls > contents.txt
echo -n "enCore.db  moo  restart" > correct.txt
if diff correct.txt correct.txt >/dev/null ; then
	echo -n "Correct Directoy contents"
	rm contents.txt correct.txt
else
	echo -n "Incorrect Directory contents"
	exit 1
fi

cd ${INSTALLDIR}/..
sudo chown -R moo moo

# Restart the enCore server
echo 'restarting enCore server'
su moo
cd ${INSTALLDIR}/bin
chmod +x restart
./restart enCore
##############################################################################

LITWORLDS_REPO_HOME=${LITWORLDS_REPO_HOME:-"/home/vagrant"}
LITWORLDS_REPO_DIR=${LITWORLDS_REPO_DIR:-"/home/vagrant/LitWorlds"}
LITWORLDS_REPO_GIT=${LITWORLDS_REPO_GIT:-"https://github.com/rhinoceraptor/LitWorlds.git"}

# install nodejs
echo 'installing nodejs'
sudo apt-get install -y nodejs
sudo apt-get install -y nodejs-legacy
sudo apt-get install -y npm

# clone and update repo
echo 'clone and updating LitWorlds to latest version'
sudo apt-get install -y git
cd $LITWORLDS_REPO_HOME
git clone $LITWORLDS_REPO_GIT
cd $LITWORLDS_REPO_DIR
git submodule update --init --recursive

# install coffescript and forever
echo 'installing coffescirpt and forever globally'
sudo npm install -g coffee-script forever cheerio

# backup and modify the apache2 ports.conf file to run on port 81
echo 'backing up ports.conf'
sudo cp /etc/apache2/ports.conf /etc/apache2/ports.$(date -d "today" +"%Y%m%d%H%M%S").conf
echo 'making changes to ports.conf'
sudo sed -i '5s/.*/Listen 81/' /etc/apache2/ports.conf

# retart apache2
echo 'restarting apache2'
sudo service apache2 restart

# install and build the node server
echo 'installing and building the node server'
cd $LITWORLDS_REPO_DIR/src/server
#####################################
# may need to add this to .json file#
sudo npm install cheerio			#
#####################################
sudo npm install
sudo cake build

# build the client application
echo 'building the client application'
cd $LITWORLDS_REPO_DIR/src/client
sudo cake build 

# start the node server
echo 'starting the node server'
cd $LITWORLDS_REPO_DIR/src/server/
sudo forever start ./dist/server.js

echo 'enCore and Node server should be running now!!!'