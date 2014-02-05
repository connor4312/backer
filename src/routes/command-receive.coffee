util = require '../lib/util'
log = require '../lib/logging'
fs = require 'fs'
filters = require '../lib/filters'

module.exports = (req, res) ->

	fs.rename req.files.file.path, util.makePath(req.body.key) ->
		if err
			log.error err
			return res.send 400
		else
			return res.send 200