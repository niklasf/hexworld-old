MapViewer = (require? "./lib/map_viewer") or window.MapViewer
PathFinder = (require? "./lib/path_finder") or window.PathFinder

$ ->
    parts = document.URL.split "/"
    game_id = parts[3]

    $.getJSON '/' + game_id + '/all.json', (data, status) ->
        viewer = new MapViewer data, '#grid'

        viewer.on 'hover', (index) ->
            viewer.set_hover_hex 67

            if index != -1
                finder = new PathFinder 10, 20
                path = finder.get_path 67, index, 30, -> 1
                viewer.set_highlighted_path path

        viewer.on 'click', (index) ->
            alert index
