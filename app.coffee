express = require 'express'
http = require 'http'

app = express()
app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use app.router
  app.use require('stylus').middleware(__dirname + '/app')
  app.use require('connect-coffee-script')(__dirname + '/app')
  app.use express.static(__dirname + '/app')
  app.use express.static(__dirname + '/bower_components')
  app.locals.pretty = true

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', (req, res) -> res.render('index')

server = http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
