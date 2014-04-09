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
INSTALLDIR=/usr/local/moo
APACHEDIR=/
#########################################################

# If anything goes wrong, abort the script
set -e

# install sudo, apache-webserver, gcc
apt-get install sudo apache2 gcc

# create a moo user, with sudo group, 
useradd -g wheel -G admin -s /bin/bash -p users -d /home/moo -m moo

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

# make the encore directory
cd ${INSTALLDIR}
mkdir encore

# go to the apache install directory and create an alias for Xpress
cd ${APACHEDIR}
echo -n "Alias /encore \"/usr/local/moo/encore\"" >> apache.conf

# check that the bin directory has the correct contents
cd ${INSTALLDIR}/bin
ls > contents.txt
echo enCore.db  moo  restart > correct.txt
if diff file1 file2 >/dev/null ; then
	echo -n "Correct Directoy contents"
	rm contents.txt correct.txt
else
	echo -n "Incorrect Directory contents"
	exit 1
fi
