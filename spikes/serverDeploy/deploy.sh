#! /bin/bash
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

# If anything goes wrong (command returns non-zero), abort the script
set -e

# install updates, sudo, apache, gcc, bison, vim non-interatively
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -q -y install sudo apache2 gcc make bison vim csh

# create a moo user, with sudo group, 
useradd -g sudo -s /bin/bash -p users -d /home/moo -m moo

# make INSTALLDIR directory
mkdir ${INSTALLDIR}
cd ${INSTALLDIR}

# wget both files
wget ${ENCORE_URL}
wget ${LAMBDA_MOO_URL}

# untar LambdaMOO and enCore to ${INSTALLDIR}
tar -zxvf LambdaMOO-1.8.1-unicode.tar.gz
tar -zxvf enCore-4.0.1.tar.gz

# make src directory and move source files to src directory
cd ${INSTALLDIR}
mkdir src
mv *.tar.gz src

# compile the MOO server
cd ${INSTALLDIR}/MOO-1.8.1
sh configure
make

# make bin directory, copy the moo server and the restart script to it
cd ${INSTALLDIR}
mkdir bin
cp MOO-1.8.1/moo bin/
cp MOO-1.8.1/restart bin/

# go to the apache install directory and create an alias for Xpress
cd ${APACHEDIR}
echo -n "Alias /encore \"/usr/local/moo/encore\"" >> apache2.conf

# Add enCore.db, moo, and restart to the bin directory
cd ${INSTALLDIR}/bin
cp ../MOO-1.8.1/moo .
cp ../MOO-1.8.1/restart .
cp ../encore/enCore.db .

# check that the bin directory has the correct contents
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
chown -R moo moo

# Restart the enCore server
cd ${INSTALLDIR}/bin
chmod +x restart
./restart enCore
