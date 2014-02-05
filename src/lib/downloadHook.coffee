util = require './util'
fs = require 'fs'

module.exports =
	action: 'download'
	controller: (req, res, params, data) ->

		return util.end(res, 400) if not params.download?

		data.redis.hget ['backer_links', params.download], (err, key) ->
			if err
				data.log.error 'Redis error: ' + err
				return util.end res, 500

			path = util.makePath(data, key)

			if not key or not fs.existsSync(path)
				data.log.info 'Sending a 404 for download of: ' + params.download
				return util.end res, 404

			data.log.debug 'Starting download of ' + key;

			stream = fs.createReadStream path, { bufferSize: 64 * 1024 }
			stream.pipe res, { end: false }

			stream.on 'end', ->
				data.log.debug 'Finished downloading ' + key
				data.redis.hdel ['backer_links', params.download], ->
				res.end()