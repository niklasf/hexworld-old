Map = require '../lib/map'
assert = require 'assert'

describe 'Heap#get_x', ->
    it 'should get the x coordinate from an index', ->
        map = new Map 5, 10
        assert.equal 0, map.get_x(0)
        assert.equal 6, map.get_x(6)
        assert.equal 7, map.get_x(17)

describe 'Heap#get_y', ->
    it 'should get the y coordinate from an index', ->
        map = new Map 5, 10
        assert.equal 0, map.get_y(0)
        assert.equal 0, map.get_y(9)
        assert.equal 1, map.get_y(10)
        assert.equal 4, map.get_y(45)
