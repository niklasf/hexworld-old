MapViewer = (require? "./lib/map_viewer") or window.MapViewer

$ ->
    parts = document.URL.split "/"
    game_id = parts[3]

    $.getJSON '/' + game_id + '/all.json', (data, status) ->
        viewer = new MapViewer data, '#grid'
        viewer.on 'hover', (index) ->
            viewer.set_hover_hex index
        viewer.on 'click', (index) ->
            alert index
