util = require './util'
app = require '../lib/express'
log = require '../lib/logging'
fs = require 'fs'
filters = require '../lib/filters'

app.post '/command/receive', filters.file, filters.key_noex, (req, res) ->

	fs.rename req.files.file.path, util.makePath(req.body.key) ->
		if err
			log.error err
			return res.send 400
		else
			return res.send 200