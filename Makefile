lib: src/path_finder.coffee src/map_generator.coffee src/map_viewer.coffee src/client.coffee src/map_viewer_base.coffee
	@coffee -c -o lib src/path_finder.coffee
	@coffee -c -o lib src/map_generator.coffee
	@coffee -c -o lib src/map_viewer_base.coffee
	@coffee -c -o lib src/map_viewer.coffee
	@coffee -c -o lib src/client.coffee

.PHONY: test
test: lib
	@mocha --compilers coffee:coffee-script test/*.coffee
