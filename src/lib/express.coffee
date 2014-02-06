config = require '../config'
log = require './logging'
filters = require './filters'
util = require './util'

express = require 'express'
app = express()

app.param 'key', (req, res, next, key) ->
	if key.match /^[A-z0-9]+$/
		next()

app.use express.bodyParser()

app.use '/command', (req, res, next) ->
	if req.body?.password is config.password
		next()
	else
		return util.end res, 403

app.get  '/download/:key', require('../routes/download')
app.post '/command/size', filters.path, require('../routes/command-size')
app.post '/command/send', filters.path, filters.key_noex, require('../routes/command-send')
app.post '/command/remove', filters.key, require('../routes/command-remove')
app.post '/command/receive', filters.file, filters.key_noex, require('../routes/command-receive')
app.post '/command/publicize', filters.key, require('../routes/command-publicize')

app.get '/', (req, res) ->
	res.end '<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>'

log.info '----------------------------------------'
log.info 'Booted HTTP server on ' + config.host + ':' + config.http_port
log.info 'Created by peet.io. Report bugs on github.'
log.info '----------------------------------------'

module.exports = app