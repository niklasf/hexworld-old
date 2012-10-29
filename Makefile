lib: src/path_finder.coffee
	@coffee -c -o lib src/path_finder.coffee

.PHONY: test
test: lib
	@mocha --compilers coffee:coffee-script test/*.coffee
