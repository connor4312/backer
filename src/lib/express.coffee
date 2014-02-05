config = require '../config'
log = require './logging'
filters = require './filters'

express = require 'express'
app = express()

app.param 'key', (req, res, next, key) ->
	if key.match /^[A-z0-9]+$/
		next()

app.use '/command', (req, res, next) ->
	if req.body?.password is data.password
		next()
	else
		return res.send 403

app.get  '/download/:key', require('../routes/download')
app.post '/command/size', filters.path, require('../routes/command-size')
app.post '/command/send', filters.path, filters.key_noex, require('../routes/command-send')
app.post '/command/remove', filters.key, require('../routes/command-remove')
app.post '/command/receive', filters.file, filters.key_noex, require('../routes/command-receive')
app.post '/command/publicize', filters.key, require('../routes/command-publicize')

log.info '----------------------------------------'
log.info 'Booted HTTP server on ' + config.host + ':' + config.http_port
log.info 'Created by peet.io. Report bugs on github.'
log.info '----------------------------------------'

module.exports = app