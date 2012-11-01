class MapViewer
    constructor: (grid, @map) ->
        @grid = $ grid
        @tiles = []
        for node in @map.nodes
            @create_tile node

        @grid.draggable
            containment: [-54 * @map.cols + 360, -72 * @map.rows + 360, 180, 180]
            distance: 20
            start: =>
                @dragging = true
                return true

        @unit = $ '<div class="unit"><img src="/images/mage.png"></div>'
        @unit.css
            position: "absolute"
            left: 0
            top: 0
            width: 72
            height: 72
        @unit.appendTo @grid
        @unit_pos = 0

        @hover_top = $ '<div class="tile"><img src="/images/hover-hex-top.png"></div>'
        @hover_top.css
            left: 0
            top: 0
            "z-index": 10
        @hover_top.appendTo @grid
        @hover_bottom = $ '<div class="tile"><img src="/images/hover-hex-bottom.png"></div>'
        @hover_bottom.css
            left: 0
            top: 0
            "z-index": 20
        @hover_bottom.appendTo @grid

        @grid.mousemove (e) =>
            index = @index_from_coordinates e.clientX, e.clientY, @grid.offset()
            pos =
                left: 54 * @map.nodes[index].col
                top: 72 * @map.nodes[index].row + (if @map.nodes[index].col % 2 == 0 then 0 else 36)
            @hover_top.css pos
            @hover_bottom.css pos

    index_from_coordinates: (left, top, offset = { left: 0, top: 0 }) ->
        x = left - offset.left
        y = top - offset.top

        ci = Math.floor(x / 54)
        cx = x - 54 * ci

        ty = y - (ci % 2) * 36
        cj = Math.floor(ty / 72)
        cy = ty - 72 * cj

        radius = Math.sqrt(18 * 18 + 36 * 36)
        if cx > Math.abs(radius / 2 - radius * cy / 72)
            return cj * @map.cols + ci
        else
            row = cj + (ci % 2) - (if cy < 36 then 1 else 0)
            col = ci - 1
            return row * @map.cols + col

    row_and_col_from_index: (index) ->
        row: Math.floor(index / @map.cols)
        col: index % @map.cols

    coordinates_from_index: (index) ->
        pos = @row_and_col_from_index(index)
        left: 54 * pos.col
        top: 72 * pos.row + (if pos.col % 2 == 0 then 0 else 36)

    create_tile: (tile) ->
        html = '<div class="tile">'
        for z, image of tile.images
            html += '<img src="' + image + '">';
        html += '</div>'

        @tiles[tile.index] = $ html
        @tiles[tile.index].css @coordinates_from_index tile.index
        @tiles[tile.index].appendTo @grid

        @tiles[tile.index].click =>
            if @dragging
                @dragging = false
                return true
            finder = new PathFinder @map.rows, @map.cols
            path = finder.get_path @unit_pos, tile.index, 20000000, (i) =>
                if @map.nodes[i].type == "grass" then 1 else 1000
            @animate_path path, @unit
            @unit_pos = tile.index

    highlight_path: (path) ->
        if path == false
            return

        for index in path
            @tiles[index].css
                border: "1px solid red"

    animate_path: (path, unit) ->
        if path.length != 0
            col = @map.nodes[path[0]].col
            row = @map.nodes[path[0]].row
            unit.animate
                left: 54 * col
                top: 72 * row + (if col % 2 == 0 then 0 else 36),
                200,
                'linear',
                => @animate_path(path[1..], unit)

if module?.exports
    module.exports = MapViewer
else
    window.MapViewer = MapViewer
