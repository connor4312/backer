util = require '../lib/util'
log = require '../lib/logging'
fs = require 'fs'
admzip = require 'adm-zip'
filters = require '../lib/filters'
redis = require '../lib/redis'

module.exports = (req, res) ->

	util.end res, 400

	redis.hset ['backer_status', req.body.key, 'restoring'], ->

	zip = new admzip(req.files.file.path)
	zip.extractAllTo req.body.path, true

	fs.unlink req.files.file.path, ->
		redis.hset ['backer_status', req.body.key, 'restored'], ->