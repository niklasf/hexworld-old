class MapViewer
    constructor: (grid, @map) ->
        @grid = $ grid
        @tiles = []
        for node in @map.nodes
            @create_tile node

        @grid.draggable
            containment: [-54 * @map.cols + 360, -72 * @map.rows + 360, 180, 180]

    create_tile: (tile) ->
        html = '<div class="tile">'
        for z, image of tile.images
            html += '<img src="' + image + '">';
        html += '</div>'

        @tiles[tile.index] = $ html
        @tiles[tile.index].css
            position: "absolute"
            left: 54 * tile.col
            top: 72 * tile.row + (if tile.col % 2 == 0 then 0 else 36)
            width: 72
            height: 72
        @tiles[tile.index].appendTo @grid

    highlight_path: (path) ->
        if path == false
            return

        for index in path
            @tiles[index].css
                border: "1px solid red"

$ ->
    generator = new MapGenerator
    viewer = new MapViewer "#grid", generator.get_grass_map 20, 20
    finder = new PathFinder 20, 20
    viewer.highlight_path finder.get_path 0, 317, 1000, -> 1
