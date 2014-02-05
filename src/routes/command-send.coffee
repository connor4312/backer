util = require './util'
exec = require('child_process').exec
request = require 'request'

app = require '../lib/express'
log = require '../lib/logging'
fs = require 'fs'

filters = require '../lib/filters'

app.post '/command/send', filters.path, filters.key_noex, (req, res) ->

	res.send 200

	exec "cd " + req.body.path + " && zip -r " + util.makePath(req.body.key) + " .", (err, result) ->
		if (err)
			log.error err

		r = request.post 'http://' + req.body.dest_host + ':' + req.body.dest_post + '/command/receive'
		form = r.form()
		form.append 'password', req.body.dest_password
		form.append 'key', req.body.key
		form.append 'file', fs.createReadStream(util.makePath(req.body.key))
		form.submit()