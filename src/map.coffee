Heap = (require? "heap") or window.Heap

class Map
    constructor: (@rows, @cols) ->
        @nodes = ({
            index: i
            row: @get_row(i)
            col: @get_col(i)
            type: 'gras'
            random: Math.random()
        } for i in [0...@rows * @cols])

    get_col: (index) ->
        index % @cols

    get_row: (index) ->
        Math.floor(index / @cols)

    get_neighbors: (index) ->
        neighbors = []

        # North.
        if @get_row(index) > 0
            neighbors.push index - @cols
        # South.
        if @get_row(index) < @rows - 1
            neighbors.push index + @cols

        if @get_col(index) % 2 == 0
            if @get_col(index) > 0
                # South-west.
                neighbors.push index - 1
                # North-west.
                if @get_row(index) > 0
                    neighbors.push index - 1 - @cols
            if @get_col(index) < @cols - 1
                # South-east.
                neighbors.push index + 1
                # North-east.
                if @get_row(index) > 0
                    neighbors.push index + 1 - @cols
        else
            if @get_col(index) > 0
                # North-west.
                neighbors.push index - 1
                # South-west.
                if @get_row(index) < @rows - 1
                    neighbors.push index - 1 + @cols
            if @get_col(index) < @cols - 1
                # North-east.
                neighbors.push index + 1
                # South-east.
                if @get_row(index) < @rows - 1
                    neighbors.push index + 1 + @cols

        return neighbors

    get_path: (from_index, to_index, cost_function) ->
        cache = ({
            closed: false
            g: 0
            previous_node: null
            f: 0
        } for i in [0...@rows * @cols])

        open_list = new Heap (a, b) ->
            return cache[a].f - cache[b].f

        expand_node = (current_node) =>
            for neighbor in @get_neighbors current_node
                if cache[neighbor].closed
                    continue

                tentative_g = cache[current_node].g + cost_function(current_node, neighbor)

                if tentative_g >= cache[neighbor].g and open_list.contains neighbor
                    continue

                neighbor.previous_node = current_node
                cache[neighbor].g = tentative_g
                cache[neighbor].f = tentative_g + h(neighbor)

                if open_list.contains neighbor
                    open_list.changeItem neighbor
                else
                    open_list.push neighbor

        open_list.push(current_node)

        while not open_list.empty()
            current_node = open_list.pop()
            if to_index == current_node
                way = [to_index]
                way.push cache[way[-1..][0]].previous_node while cache[way[-1..][0]].previous_node
                return way
            expand_node current_node
            cache[current_node].closed = true

        return false

if module?.exports
    module.exports = Map
else
    window.Map = Map
