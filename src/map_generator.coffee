class MapGenerator
    get_grass_map: (rows, cols) ->
        cols: cols
        rows: rows
        nodes: ({
            type: "grass"
            images:
                0: "images/green.png"
        } for i in [0...cols * rows])

if module?.exports
    module.exports = MapGenerator
else
    window.MapGenerator = MapGenerator
