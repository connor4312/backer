util = require '../lib/util'
exec = require('child_process').exec
formdata = require 'form-data'

log = require '../lib/logging'
fs = require 'fs'
archiver = require 'archiver'

filters = require '../lib/filters'

module.exports = (req, res) ->

	util.end res, 200

	redis.hset ['backer_status', req.body.key, 'zipping'], ->

	path = util.makePath(req.body.key)

	archiver.create('zip').bulk([{
		expand: true
		cwd: path
		src: ['**']
		dest: util.makePath(req.body.key)
	}]).finalize (err, byte) ->

		if (err)
			redis.hset ['backer_status', req.body.key, 'stored:zipping_fail'], ->
			log.error err

		redis.hset ['backer_status', req.body.key, 'sending'], ->

		form = new formdata
		form.append 'password', req.body.dest_password
		form.append 'key', req.body.key
		form.append 'file', fs.createReadStream(path)
		form.submit 'http://' + req.body.dest_host + ':' + req.body.dest_post + '/command/receive', (err, res) ->
			if err
				redis.hset ['backer_status', req.body.key, 'stored:send_fail'], ->
			else
				redis.hset ['backer_status', req.body.key, 'stored:send_success'], ->