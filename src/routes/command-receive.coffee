util = require '../lib/util'
log = require '../lib/logging'
fs = require 'fs'
filters = require '../lib/filters'
redis = require '../lib/redis'

module.exports = (req, res) ->

	fs.rename req.files.file.path, util.makePath(req.body.key) ->
		if err
			log.error err
			return util.end res, 400
		else
			redis.hset ['backer_status', req.body.key, 'stored'], ->
			return util.end res, 200