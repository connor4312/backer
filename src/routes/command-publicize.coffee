filters = require '../lib/filters'
redis = require '../lib/redis'
util = require '../lib/util'

module.exports = (req, res) ->
	return util.end(res, 400) if not req.body.link?

	redis.hset ['backer_links', req.body.link, req.body.key], ->
	util.end res, 200