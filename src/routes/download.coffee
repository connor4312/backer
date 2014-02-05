app = require '../lib/express'
log = require '../lib/logging'
redis = require '../lib/redis'
util = require '../lib/util'
fs = require 'fs'

app.get '/download/:key', (req, res) ->

	redis.hget ['backer_links', req.params.key], (err, key) ->
		if err
			data.log.error 'Redis error: ' + err
			return res.send 500

		path = util.makePath(data, key)

		if not key or not fs.existsSync(path)
			log.info 'Sending a 404 for download of: ' + req.params.key
			return res.send 404

		log.debug 'Starting download of ' + key;

		stream = fs.createReadStream path, { bufferSize: 64 * 1024 }
		stream.pipe res, { end: false }

		stream.on 'end', ->
			log.debug 'Finished downloading ' + key
			redis.hdel ['backer_links', req.params.key], ->
			res.end()