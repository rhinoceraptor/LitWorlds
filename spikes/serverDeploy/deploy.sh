# Server deploy script
# LambdaMOO and enCore db
# Literary Worlds - CS 4900
# Jack Lewis
#########################################################
# Constants
ENCORE_URL=http://downloads.sourceforge.net/project/ele/enCore%20Database/enCore%204.0.1/enCore-4.0.1.tar.gz
LAMBDA_MOO_URL=http://lingo.uib.no/v5/downloads/LambdaMOO-1.8.1-unicode.tar.gz
#########################################################

# wget both files
wget ${ENCORE_URL}
wget ${LAMBDA_MOO_URL}

# untar LambdaMOO and enCore
tar -zxvf LambdaMOO-1.8.1-unicode.tar.gz
tar -zxvf enCore-4.0.1.tar.gz

# make src directory and move source files to src directory
mkdir src
mv *.tar.gz src

# 