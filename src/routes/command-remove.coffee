util = require './util'
exec = require('child_process').exec
app = require '../lib/express'
filters = require '../lib/filters'

app.post '/command/remove', filters.key, (req, res) ->
	exec 'rm -f ' +  util.makePath(req.body.key), (err) ->
		res.send err ? 500 : 200