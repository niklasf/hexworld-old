class MapGenerator
    get_grass_map: (rows, cols) ->
        cols: cols
        rows: rows
        nodes: ({
            index: i
            col: i % cols
            row: Math.floor(i / cols)
            type: "grass"
            images:
                0: "/images/green.png"
        } for i in [0...cols * rows])

    get_random_map: (rows, cols) ->
        map = @get_grass_map rows, cols
        for node in map.nodes
            if Math.random() > 0.6
                node.type = "water"
                node.images[0] = "/images/coast.png"
        return map

if module?.exports
    module.exports = MapGenerator
else
    window.MapGenerator = MapGenerator
