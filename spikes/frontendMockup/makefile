export SHELL=/bin/bash
srcBuild= ./lib/app/ ./src/*.coffee
modalBuild = ./lib/app/modals/ ./src/modals/*.coffee

build:
	coffee -c -o $(srcBuild)
	coffee -c -o $(modalBuild)