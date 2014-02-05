log = require '../lib/logging'
redis = require '../lib/redis'
util = require '../lib/util'
filters = require '../lib/filters'
fs = require 'fs'

module.exports = (req, res) ->
	redis.hget ['backer_links', req.params.key], (err, key) ->
		debugger;
		if err
			log.error 'Redis error: ' + err
			return util.end res, 500

		path = util.makePath key

		if not key or not fs.existsSync(path)
			log.info 'Sending a 404 for download of: ' + req.params.key
			return util.end res, 404

		log.debug 'Starting download of ' + key;

		stream = fs.createReadStream path, { bufferSize: 64 * 1024 }
		stream.pipe res, { end: false }

		stream.on 'end', ->
			log.debug 'Finished downloading ' + key
			redis.hdel ['backer_links', req.params.key], ->
			res.end()