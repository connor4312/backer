util = require '../lib/util'
exec = require('child_process').exec
filters = require '../lib/filters'
log = require '../lib/logging'

module.exports = (app) ->
	app.post '/command/size', filters.path, (req, res) ->

		exec "du -c -s " + req.body.path + " | grep total | awk '{print $1/1024}'", (err, result) ->
			if err
				log.error 'Error when sizing ' + req.body.path + ': ' + err
				return res.send(500)

			res.send result