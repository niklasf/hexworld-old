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

describe 'Map#get_neighbors', ->
    it 'should return the neighbors of an index', ->
        map = new Map 3, 4

        assert.ok 1 in map.get_neighbors 0
        assert.ok 4 in map.get_neighbors 0
        assert.equal 2, map.get_neighbors(0).length

        assert.ok 1 in map.get_neighbors 5
        assert.ok 4 in map.get_neighbors 5
        assert.ok 6 in map.get_neighbors 5
        assert.ok 8 in map.get_neighbors 5
        assert.ok 9 in map.get_neighbors 5
        assert.ok 10 in map.get_neighbors 5
        assert.equal 6, map.get_neighbors(5).length

        assert.ok 3 in map.get_neighbors 7
        assert.ok 6 in map.get_neighbors 7
        assert.ok 10 in map.get_neighbors 7
        assert.ok 11 in map.get_neighbors 7
        assert.equal 4, map.get_neighbors(7).length

describe 'Map#get_path', ->
    it 'should get the direct path from an index to an index', ->
        map = new Map 3, 4
        path = map.get_path 0, 3, -> 1
        assert.equal 1, path[0]
        assert.equal 2, path[1]
        assert.equal 3, path[2]
        assert.equal 3, path.length
