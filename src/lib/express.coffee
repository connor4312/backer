config = require '../config'
log = require './lib/logging'

express = require 'express'
app = express()

app.param('key', /^[A-z0-9]+$/);

app.use '/command', (req, res, next) ->
	if req.body?.password is data.password
		next()
	else
		return res.send 403

app.listen config.http_port

log.info '----------------------------------------'
log.info 'Booted HTTP server on ' + config.host + ':' + config.http_port
log.info 'Created by peet.io. Report bugs on github.'
log.info '----------------------------------------'

module.exports = app