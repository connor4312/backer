util = require '../lib/util'
log = require '../lib/logging'
fs = require 'fs'
mkdirp = require 'mkdirp'
async = require 'async'

exec = require('child_process').exec
filters = require '../lib/filters'
redis = require '../lib/redis'

module.exports = (req, res) ->

	util.end res, 400

	redis.hset ['backer_status', req.body.key, 'restoring'], ->

	async.series [
		(cb) -> mkdirp req.body.path, cb
		(cb) -> exec 'rm -rf ' + req.body.path + '/*', cb
		(cb) -> exec 'unzip ' + req.files.file.path + ' -d ' + req.body.path
		(cb) ->
			fs.unlink req.files.file.path, ->
			redis.hset ['backer_status', req.body.key, 'restored'], -> cb
	]