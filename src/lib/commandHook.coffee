util = require './util'
exec = require 'exec'

module.exports =
	action: 'command'
	controller: (req, res, params, data) ->

		post = {}
		util.end(res, 403) if post.password isnt data.password

		switch params.command
			when 'removeZip'
				return util.end(res, 400) if not params.key? or not params.key.match(/^[A-z0-9]+$/)
				exec.exec 'rm -f ' + util.makePath(data, key)

			when 'publicize'
				return util.end(res, 400) if not params.key? or not params.key.match(/^[A-z0-9]+$/)
				return util.end(res, 400) if not params.link? or not params.link.match(/^[A-z0-9]+$/)
				return util.end(res, 404) if not fs.existsSync(util.makePath(data, key))

				data.redis.hset ['backer_links', post.link, post.key]

			when 'sizeFolder'
				return util.end(res, 400) if not params.path?
				return util.end(res, 404) if not fs.existsSync(path)

			when 'transferFolder'
				return util.end(res, 400) if not params.path?
				return util.end(res, 404) if not fs.existsSync(path)

			else
				util.end(res, 400) if not params.download?