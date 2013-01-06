# BindingOfSamus
#
# Author: Andreas Hoffmann <furizaa@gmail.com>

http    = require 'http'
express = require 'express'
fs      = require 'fs'
app     = express()

app.configure () ->
    app.use express.static __dirname + '/public'
    app.use express.bodyParser()
    app.set 'views', __dirname + '/views'
    app.set 'view engine', 'jade'

app.get '/', (req, res) ->
    res.render 'layout'

app.get '/level/:filename', (req, res) ->
    file = __dirname + '/levels/' + req.params.filename
    fs.readFile file, (err, json) ->
        res.writeHeader 200,
            'Content-Type': 'application/x-json'
            'Content-Length': json.length
        res.write json
        res.end()

app.post '/level/:filename', (req, res) ->
    file = __dirname + '/levels/' + req.params.filename
    fs.writeFile file, JSON.stringify( req.body, null, 4 ), 'utf-8', ->
        res.writeHeader 200
        res.end()

port = process.env.PORT || 3000
http.createServer(app).listen(port)

console.log 'And the monkeys are listening on ' + port