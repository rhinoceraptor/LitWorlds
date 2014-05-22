buildSpec 	= ./dist/spec/ ./spec/rpnSpec.coffee 
buildSrc 	= ./dist/src/ ./src/*.coffee 

build:
	 coffee -c -b -o $(buildSrc)
	 coffee -c -b -o $(buildSpec)

watch:
	screen -S watchSrc -d -m bash -c 'coffee -w -b -o $(buildSrc)'
	screen -S watchSpec -d -m bash -c 'coffee -w -b -o $(buildSpec)'

stop:
	screen -X -S watchSrc quit
	screen -X -S watchSpec quit