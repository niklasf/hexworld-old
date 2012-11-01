MapViewerBase = (require? "map_viewer_base") or window.MapViewerBase

class MapViewer extends MapViewerBase
    constructor: (map, grid) ->
        super(map)

        @grid = $ grid

        # Create the tiles.
        @tiles = []
        for node in @map.nodes
            @create_tile node

        # Make the grid draggable.
        @grid.draggable
            containment: [-54 * @map.cols + 360, -72 * @map.rows + 360, 180, 180]
            distance: 20
            start: =>
                @dragging = true

        # Append the cursor hover images.
        @hover_top = $ '<div class="tile"><img src="/images/hover-hex-top.png"></div>'
        @hover_top.appendTo @grid
        @hover_bottom = $ '<div class="tile"><img src="/images/hover-hex-bottom.png"></div>'
        @hover_bottom.appendTo @grid

        @grid.mousemove (e) =>
            index = @index_from_coordinates e.clientX, e.clientY, @grid.offset()
            @emit "hover_tile", index
        @grid.mouseleave (e) =>
            @emit "hover_tile", -1

    create_tile: (tile) ->
        html = '<div class="tile">'
        for z, image of tile.images
            html += '<img src="' + image + '">'
        html += '</div>'

        @tiles[tile.index] = $ html
        @tiles[tile.index].css @coordinates_from_index tile.index
        @tiles[tile.index].appendTo @grid

    set_hover_hex: (index) ->
        if index == -1
            @hover_top.hide()
            @hover_bottom.hide()
        else
            coords = @coordinates_from_index index
            @hover_top.css(coords).show()
            @hover_bottom.css(coords).show()

if module?.exports
    module.exports = MapViewer
else
    window.MapViewer = MapViewer
