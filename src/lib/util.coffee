config = require '../config'

module.exports =
	makePath: (key) ->
		return config.file_path + key + '.zip'

	end: (res, response) ->
		res.writeHead response
		res.end()