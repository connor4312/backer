app = require '../lib/express'
filters = require '../lib/filters'
redis = require '../lib/redis'

app.post '/command/publicize', filters.key, (req, res) ->
	return res.send(400) if not req.body.link?

	data.redis.hset ['backer_links', req.body.link, req.body.key]
	res.send 400