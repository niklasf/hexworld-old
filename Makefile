lib: src/path_finder.coffee src/map_generator.coffee src/map_viewer.coffee
	@coffee -c -o lib src/path_finder.coffee
	@coffee -c -o lib src/map_generator.coffee
	@coffee -c -o lib src/map_viewer.coffee

.PHONY: test
test: lib
	@mocha --compilers coffee:coffee-script test/*.coffee
