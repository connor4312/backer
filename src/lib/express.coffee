config = require '../config'
log = require './logging'

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

log.info '----------------------------------------'
log.info 'Booted HTTP server on ' + config.host + ':' + config.http_port
log.info 'Created by peet.io. Report bugs on github.'
log.info '----------------------------------------'

module.exports = app