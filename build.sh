#!/bin/bash

echo 'compiling source CoffeeScript to JavaScript'
coffee -c -b -o ./dist/spec/ ./spec/rpnSpec.coffee 
coffee -c -b -o ./dist/src/ ./src/rpnCalc.coffee 