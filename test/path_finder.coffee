PathFinder = require '../lib/path_finder'
assert = require 'assert'

describe 'PathFinder#get_col', ->
    it 'should get the column from an index', ->
        path_finder = new PathFinder 5, 10
        assert.equal 0, path_finder.get_col(0)
        assert.equal 6, path_finder.get_col(6)
        assert.equal 7, path_finder.get_col(17)

describe 'PathFinder#get_y', ->
    it 'should get the row from an index', ->
        path_finder = new PathFinder 5, 10
        assert.equal 0, path_finder.get_row(0)
        assert.equal 0, path_finder.get_row(9)
        assert.equal 1, path_finder.get_row(10)
        assert.equal 4, path_finder.get_row(45)

describe 'PathFinder#get_neighbors', ->
    it 'should return the neighbors of an index', ->
        path_finder = new PathFinder 3, 4

        assert.ok 1 in path_finder.get_neighbors 0
        assert.ok 4 in path_finder.get_neighbors 0
        assert.equal 2, path_finder.get_neighbors(0).length

        assert.ok 1 in path_finder.get_neighbors 5
        assert.ok 4 in path_finder.get_neighbors 5
        assert.ok 6 in path_finder.get_neighbors 5
        assert.ok 8 in path_finder.get_neighbors 5
        assert.ok 9 in path_finder.get_neighbors 5
        assert.ok 10 in path_finder.get_neighbors 5
        assert.equal 6, path_finder.get_neighbors(5).length

        assert.ok 3 in path_finder.get_neighbors 7
        assert.ok 6 in path_finder.get_neighbors 7
        assert.ok 10 in path_finder.get_neighbors 7
        assert.ok 11 in path_finder.get_neighbors 7
        assert.equal 4, path_finder.get_neighbors(7).length

describe 'PathFinder#get_path', ->
    it 'should get the direct path from an index to an index', ->
        path_finder = new PathFinder 3, 4
        path = path_finder.get_path 0, 3, 100, -> 1
        assert.equal 1, path[0]
        assert.equal 2, path[1]
        assert.equal 3, path[2]
        assert.equal 3, path.length

    it 'should go around expensive nodes', ->
        path_finder = new PathFinder 3, 4
        path = path_finder.get_path 0, 8, 100, (index) ->
            if index is 4 then 10 else 1
        assert.equal 1, path[0]
        assert.equal 5, path[1]
        assert.equal 8, path[2]
        assert.equal 3, path.length

    it 'should respect unpassable nodes', ->
        path_finder = new PathFinder 3, 4
        path = path_finder.get_path 0, 11, 100, (index) ->
            if index in [4, 1] then false else 1
        assert.ok false == path
