module.exports = (settings) ->
	return {
		makePath: (key) ->
			return settings.path + key + '.zip'
	}