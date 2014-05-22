build:
	coffee -c -b -o ./dist/spec/ ./spec/rpnSpec.coffee 
	coffee -c -b -o ./dist/src/ ./src/rpnCalc.coffee 

watch:
	coffee -w -b -o ./dist/spec/ ./spec/rpnSpec.coffee &
	coffee -w -b -o ./dist/src/ ./src/rpnCalc.coffee &