MapViewer = (require? "./lib/map_viewer") or window.MapViewer

$ ->
    parts = document.URL.split "/"
    game_id = parts[3]

    $.getJSON '/' + game_id + '/all.json', (data, status) ->
        new MapViewer data, '#grid'
