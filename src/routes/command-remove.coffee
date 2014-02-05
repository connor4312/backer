util = require '../lib/util'
fs = require 'fs'

module.exports = (req, res) ->
	fs.unlink util.makePath(req.body.key), ->
	util.end res, 200