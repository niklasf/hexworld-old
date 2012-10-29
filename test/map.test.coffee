Map = require '../lib/map'
assert = require 'assert'

describe 'Map#get_col', ->
    it 'should get the column from an index', ->
        map = new Map 5, 10
        assert.equal 0, map.get_col(0)
        assert.equal 6, map.get_col(6)
        assert.equal 7, map.get_col(17)

describe 'Map#get_y', ->
    it 'should get the row from an index', ->
        map = new Map 5, 10
        assert.equal 0, map.get_row(0)
        assert.equal 0, map.get_row(9)
        assert.equal 1, map.get_row(10)
        assert.equal 4, map.get_row(45)

describe 'Map#get_path', ->
    it 'should get the path from an index to an index', ->
        map = new Map 5, 10
        assert.equal [0, 1, 2, 3], map.get_path 0, 3, -> 1
