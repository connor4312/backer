util = require '../lib/util'
log = require '../lib/logging'
filters = require '../lib/filters'
redis = require '../lib/redis'

fs = require 'fs'
http = require 'http'
formdata = require 'form-data'


module.exports = (req, res) ->

	util.end res, 200
	return util.end(res, 400) if not (req.body.dest_host and req.body.dest_port and req.body.dest_password and req.body.path)

	redis.hset ['backer_status', req.body.key, 'sending'], ->
	
	form = new formdata
	form.append 'password', req.body.dest_password
	form.append 'key', req.body.key
	form.append 'path', req.body.path
	form.append 'file', fs.createReadStream(util.makePath(req.body.key))

	request = http.request
		method: 'POST',
		hostname: req.body.dest_host
		port: req.body.dest_port
		path: '/command/receive/restore',
		headers: form.getHeaders()
	
	form.pipe request

	request.on 'error', (err) ->
		log.error err
		redis.hset ['backer_status', req.body.key, 'stored:send_fail'], ->

	request.on 'response', (res) ->
		redis.hset ['backer_status', req.body.key, 'stored:send_success'], ->


