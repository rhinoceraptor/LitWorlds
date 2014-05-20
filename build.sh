#!/bin/bash

coffee -c -b -o ./dist/src/ ./src/{Basket,Item}.coffee
coffee -c -b -o ./dist/spec/ ./spec/BasketSpec.coffee
