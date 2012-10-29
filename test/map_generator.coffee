MapGenerator = require '../lib/map_generator'
assert = require 'assert'

describe 'MapGenerator#get_grass_map', ->
    it 'should get a map of the correct size', ->
        generator = new MapGenerator
        map = generator.get_grass_map(3, 4)
        assert.equal map.rows, 3
        assert.equal map.cols, 4
        assert.equal map.nodes.length, 12 
