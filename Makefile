lib/map.js: src/map.coffee
	@coffee -c -o lib src/map.coffee

.PHONY: test
test:
	@mocha --compilers coffee:coffee-script test/*.coffee
