express = require 'express'
http = require 'http'
mongo = require 'mongodb'
MapGenerator = require './lib/map_generator'

db_server = new mongo.Server 'localhost', 27017,
    auto_reconnect: true

db = new mongo.Db 'test', db_server,
    safe: true

db.open (err, db) ->
    if err then throw err

    app = express()

    app.configure ->
        app.use '/images', express.static __dirname + '/images'
            maxAge: 84000
        app.use '/lib', express.static __dirname + '/lib'
        app.use '/vendor', express.static __dirname + '/vendor'
        app.use '/node_modules/heap/lib/', express.static __dirname + '/node_modules/heap/lib'
        app.use express.logger 'dev'

    app.get '/', (req, res) ->
        # Redirect to a game to have a background.
        db.collection 'games', (err, games) ->
            throw err if err
            games.findOne (err, game) ->
                throw err if err
                res.redirect 307, '/' + game._id + '/'
                return

    app.param 'game', (req, res, next, game_id) ->
        # Loads a game parameter from a URL to populate req.game.
        if not game_id.match /^[a-f0-9]{24}$/
            next('route')
        else
            db.collection 'games', (err, games) ->
                return next(err) if err
                games.findOne
                    _id: new mongo.ObjectID(game_id),
                    (err, game) ->
                        return next(err) if err
                        if not game
                            next('route')
                        else
                            req.game = game
                            next()

    app.get '/:game/', (req, res) ->
        res.sendfile 'index.html'

    app.get '/:game/:player', (req, res, next) ->
        console.log req.params.player
        console.log req.game
        player = req.game.players.indexOf req.params.player
        return next('route') if player is -1

        res.sendfile 'index.html'

    app.get '/generate_map', (req, res, next) ->
        db.collection 'games', (err, games) ->
             games.findOne (err, game) ->
                 generator = new MapGenerator
                 game.map = generator.get_grass_map 10, 20
                 games.save game

    app.get '/:game/all.json', (req, res, next) ->
        res.json req.game.map

    """app.get '/:game/delta.json', (req, res, next) ->
        db.collection 'events', (err, events) ->
            events.find
                "game": req.game._id
                "id"""

    app.get '/style.css', (req, res) ->
        res.sendfile 'style.css'

    server = http.createServer app
    server.listen 8888
    console.log "Listening..."
