hooks = []
data = {}

util = require('./util')

module.exports =
	add: (module)->
		mod = require './' + module + 'Hook'
		hooks.push { controller: mod.controller, action: mod.action }

	set: (_data) -> data = _data

	dispatch: (req, res) ->
		params = require('url').parse(req.url, true).query

		return util.end(res, 400) if not params.action
		
		for hook in hooks
			if hook.action is params.action
				return hook.controller req, res, params, data

		return util.end res, 400