http = require 'http';

module.exports = (data)-> 

	server = http.createServer (req, res) ->

		params = require('url').parse(req.url, true).query

		if params.download?

			if publics[ params.download ] == 'undefined') {
				return res.end('404');
			}

			logger.info('Starting download of backups/' + publics[ params.download ]);
			var stream = fs.createReadStream(config.filepath + "backups/" + publics[ params.download ], { bufferSize: 64 * 1024 });
			stream.pipe(res, { end: false });

			stream.on('end', function() {
				logger.info('Finished downloading backups/' + publics[ params.download ]);
				delete publics[ params.download ];
				delete stream;
				res.end();
			});

		} else if (typeof params.name != 'undefined') {
			res.writeHead(200, {'Content-Type': 'text/plain'});
			
			if (name = require('url').parse(req.url, true).query.name) {
				if (statuses[name]) {
					return res.end(statuses[name]);
				} else {
					return res.end('404');
				}
			} else {
				return res.end('400');
			}
		}

	server.listen(data.http_port, data.host);