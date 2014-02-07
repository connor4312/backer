util = require '../lib/util'
log = require '../lib/logging'
redis = require '../lib/redis'

module.exports = (req, res) ->

	redis.hgetall ['backer_status'], (err, data) ->
		if err
			log.error err
			return util.end res, 200

		res.send data
		return util.end res, 400