EventEmitter2 = ((require? "eventemitter2") or window).EventEmitter2

class MapViewerBase extends EventEmitter2
    constructor: (@map) ->

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
            row  = cj
            col = ci
        else
            row = cj + (ci % 2) - (if cy < 36 then 1 else 0)
            col = ci - 1

        if col < 0 or col >= @map.cols
            return -1
        else if row < 0 or row >= @map.rows
            return -1
        else
            return row * @map.cols + col

    row_and_col_from_index: (index) ->
        row: Math.floor(index / @map.cols)
        col: index % @map.cols

    coordinates_from_index: (index) ->
        pos = @row_and_col_from_index(index)
        left: 54 * pos.col
        top: 72 * pos.row + (if pos.col % 2 == 0 then 0 else 36)

if module?.exports
    module.exports = MapViewerBase
else
    window.MapViewerBase = MapViewerBase
