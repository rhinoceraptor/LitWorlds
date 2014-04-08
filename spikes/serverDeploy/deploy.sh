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
#########################################################

# install sudo, apache-webserver, gcc
apt-get install sudo apache2, gcc

# create a moo user, with sudo group, 
useradd -g wheel -G admin -s /bin/bash -p users -d /home/moo -m moo

# make /usr/local/moo directory
mkdir /usr/local/moo
cd /usr/local/moo

# wget both files
wget ${ENCORE_URL}
wget ${LAMBDA_MOO_URL}

# untar LambdaMOO and enCore to /usr/local/moo
tar -zxvf LambdaMOO-1.8.1-unicode.tar.gz
tar -zxvf enCore-4.0.1.tar.gz

# make src directory and move source files to src directory
mkdir src
mv *.tar.gz src

# compile the MOO server
cd MOO-1.8.1
sh configure
make

# make bin directory, copy the moo server and the restart script to it
cd ..
mkdir bin
cp MOO-1.8.1/moo bin/
cp MOO-1.8.1/restart bin/
