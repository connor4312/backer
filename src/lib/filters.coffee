require 'fs'
require './util'

module.exports = 
	key: (req, res, next) ->
		if req.body.key? and req.body.key.match(/^[A-z0-9]+$/) and fs.existsSync(util.makePath(key))
			next()
		else
			res.send 400
	key_noex: (req, res, next) ->
		if req.body.key? and req.body.key.match(/^[A-z0-9]+$/)
			next()
		else
			res.send 400

	path: (req, res, next) ->
		if req.body.path? and fs.existsSync(req.body.path)
			next()
		else
			res.send 400

	file: (req, res, next) ->
		if req.files.file?
			next()
		else
			res.send 400