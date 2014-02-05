module.exports =

	end: (res, response) ->
		res.writeHead response
		res.end();

	makePath: (settings, key) ->
		return settings.file_path + key + '.zip'