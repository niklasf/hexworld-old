lib/map.js: src/map.coffee
	@coffee -c -o lib src/map.coffee

.PHONY: test
test: lib/map.js
	@mocha --compilers coffee:coffee-script test/*.coffee
