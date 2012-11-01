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

        @hover_index = -1

        @grid.mousemove (e) =>
            index = @index_from_coordinates e.clientX, e.clientY, @grid.offset()
            if index != @hover_index
                @hover_index = index
                @emit "hover", index

        @grid.mouseleave (e) =>
            if @hover_index != -1
                @hover_index = -1
                @emit "hover", -1

        @grid.click (e) =>
            index = @index_from_coordinates e.clientX, e.clientY, @grid.offset()
            @emit "click", index if index != -1

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

    get_footsteps: (from, to) ->
        console.log from + "<-->" + to
        if to == from + @map.cols
            return ["foot-normal-in-n.png", "foot-normal-out-n.png"]
        else if to == from - @map.cols
            return ["foot-normal-out-n.png", "foot-normal-in-n.png"]
        if to % 2 == 0
            if to == from + 1
                return ["foot-normal-out-ne.png", "foot-normal-in-ne.png"]
            else if to == from - 1
                return ["foot-normal-in-se.png", "foot-normal-out-se.png"]
            else if to == from + @map.cols + 1
                return ["foot-normal-out-se.png", "foot-normal-in-se.png"]
            else if to == from + @map.cols - 1
                return ["foot-normal-in-ne.png", "foot-normal-out-ne.png"]
        else
            if to == from + 1
                return ["foot-normal-out-se.png", "foot-normal-in-se.png"]
            else if to == from - 1
                return ["foot-normal-in-ne.png", "foot-normal-out-ne.png"]
            else if to == from - @map.cols + 1
                return ["foot-normal-out-ne.png", "foot-normal-in-ne.png"]
            else if to == from - @map.cols - 1
                return ["foot-normal-in-se.png", "foot-normal-out-se.png"]

    set_highlighted_path: (start_index, path) ->
        @grid.children('.path').remove()

        if not path then return

        path = path[..]
        path.unshift start_index

        for i in [0...path.length - 1]
            [one, two] = @get_footsteps path[i], path[i + 1]

            tile = $ '<div class="tile path"><img src="/images/footsteps/' + one + '"></div>'
            tile.css @coordinates_from_index path[i]
            tile.appendTo @grid

            tile = $ '<div class="tile path"><img src="/images/footsteps/' + two + '"></div>'
            tile.css @coordinates_from_index path[i + 1]
            tile.appendTo @grid

if module?.exports
    module.exports = MapViewer
else
    window.MapViewer = MapViewer
