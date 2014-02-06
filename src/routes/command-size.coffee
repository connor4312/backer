util = require '../lib/util'
filters = require '../lib/filters'
log = require '../lib/logging'
fs = require 'fs'
async = require 'async'
path = require 'path'

# Based off http://stackoverflow.com/questions/7529228/how-to-get-totalsize-of-files-in-directory
readSizeRecursive = (item, cb) ->
	fs.lstat item, (err, stats) ->
		total = stats.size
		if not err and stats.isDirectory()
			fs.readdir item, (err, list) ->
				async.forEach list, ((diritem, callback) ->
					readSizeRecursive path.join(item, diritem), (err, size) ->
						total += size
						callback err
						return

					return
				), (err) ->
					cb err, total

		else
			cb err, total

module.exports = (req, res) ->

	readSizeRecursive req.body.path, (err, result) ->
		if err
			log.error 'Error when sizing ' + req.body.path + ': ' + err
			return res.send(500)

		result = Math.round(result / 1024)
		res.end String(result)