http = require 'http'
fs = require 'fs'

end = (res, response) ->
	res.writeHead(response);
	res.end();

module.exports = (data) -> 

	util = require('./util')(data);

	server = http.createServer (req, res) ->

		params = require('url').parse(req.url, true).query
		return end(res, 400) if not params.download?

		hget 'backer_links', params.download, (name) ->
			if not data or not fs.existsSync(util.makePath(name))
				logger.info 'Sending a 404 for download of:' + params.download
				return end(res.end, 404)

			logger.debug 'Starting download of ' + name;

			stream = fs.createReadStream(util.makePath(name), { bufferSize: 64 * 1024 });
			stream.pipe(res, { end: false });

			stream.on 'end', ->
				logger.info('Finished downloading ' + name);
				hdel 'backer_links', name
				res.end();

	server.listen(data.http_port, data.host);

	data.log.info 'Booted HTTP server on ' + data.host + ':' + data.http_port