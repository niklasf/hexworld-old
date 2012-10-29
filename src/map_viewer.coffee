class MapViewer
    constructor: (grid, @map) ->
        @grid = $ grid
        @tiles = []
        for node in @map.nodes
            @create_tile node

        @grid.draggable
            containment: [-54 * @map.cols + 360, -72 * @map.rows + 360, 360, 360]

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

    

$ ->
    generator = new MapGenerator
    new MapViewer "#grid", generator.get_grass_map 50, 40 
