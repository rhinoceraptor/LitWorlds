#! /bin/bash
#########################################################
# Server deploy script from a bare debian install
# LambdaMOO and enCore db
# Literary Worlds - CS 4900
# Jack Lewis
#########################################################
# URLs for server and db
ENCORE_URL=http://downloads.sourceforge.net/project/ele/enCore%20Database/enCore%204.0.1/enCore-4.0.1.tar.gz
LAMBDA_MOO_URL=https://github.com/rhinoceraptor/lambdamoo.git
# Directories for installation
INSTALLDIR=/usr/local/moo
APACHEDIR=/etc/apache2
#########################################################

# If anything goes wrong (command returns non-zero), abort the script
set -e

# install updates, sudo, apache, gcc, bison, vim non-interatively
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get -q -y install sudo apache2 gcc make bison vim git csh

# create a moo user, with sudo group,
useradd -g sudo -s /bin/bash -p users -d /home/moo -m moo

# make INSTALLDIR directory
mkdir ${INSTALLDIR}
cd ${INSTALLDIR}

# wget enCore, git clone LambdaMOO
wget ${ENCORE_URL}
git clone https://github.com/rhinoceraptor/lambdamoo.git

# untar enCore to ${INSTALLDIR}
tar -zxvf enCore-4.0.1.tar.gz

# make src directory and move source files to src directory
cd ${INSTALLDIR}
mkdir src
mv *.tar.gz src

# compile the MOO server
cd ${INSTALLDIR}/lambdamoo
sh configure
make

# make bin directory, copy the moo server and the restart script to it
cd ${INSTALLDIR}
mkdir bin
cp lambdamoo/moo bin/
cp lambdamoo/restart bin/

# go to the apache install directory and create an alias for Xpress
cd ${APACHEDIR}
echo -e "Alias /encore \"/usr/local/moo/encore\"\n<Directory /usr/local/moo/encore>\n\tRequire all granted\n</Directory>\n" >> apache2.conf

# Add enCore.db, moo, and restart to the bin directory
cd ${INSTALLDIR}/bin
cp ../lambdamoo/moo .
cp ../lambdamoo/restart .
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

# Start the enCore server
su moo
cd ${INSTALLDIR}/bin
chmod 755 restart

# Restart Apache
service apache2 restart

# Inform user of configuration needed to enCore database inside MOO
echo -n "To access the MOO, connect via telnet on localhost on port 7777, run '@configure', and set the domain name to:"
ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'
echo -n ", (option 8), and set the base URL to http://"
ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'
echo -n -e "/encore\n"

echo "You also need to set a password for the moo user on your system."
exit
