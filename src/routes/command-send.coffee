util = require '../lib/util'
log = require '../lib/logging'
filters = require '../lib/filters'
redis = require '../lib/redis'

fs = require 'fs'
archiver = require 'archiver'
http = require 'http'
formdata = require 'form-data'


module.exports = (req, res) ->

	return util.end(res, 400) if not (req.body.dest_host and req.body.dest_port and req.body.dest_password)

	util.end res, 200

	redis.hset ['backer_status', req.body.key, 'zipping'], ->

	path = util.makePath(req.body.key)
	archive = archiver.create('zip')

	archive.bulk [{
		expand: true
		cwd: req.body.path
		src: ['**']
		dest: ''
	}]

	archive.pipe fs.createWriteStream(path)
	archive.finalize (err, byte) ->

		if (err)
			redis.hset ['backer_status', req.body.key, 'stored:zipping_fail'], ->
			log.error err

		redis.hset ['backer_status', req.body.key, 'sending'], ->
		
		form = new formdata
		form.append 'password', req.body.dest_password
		form.append 'key', req.body.key
		form.append 'file', fs.createReadStream(path)

		request = http.request
			method: 'POST',
			hostname: req.body.dest_host
			port: req.body.dest_port
			path: '/command/receive',
			headers: form.getHeaders()
		
		form.pipe request

		request.on 'error', (err) ->
			debugger;
			log.error err
			redis.hset ['backer_status', req.body.key, 'stored:send_fail'], ->

		request.on 'response', (res) ->
			debugger;
			redis.hset ['backer_status', req.body.key, 'stored:send_success'], ->


