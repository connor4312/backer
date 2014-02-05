log = require './lib/logging'

http = require 'http'
hooks = require './lib/hooks'

hooks.set data
hooks.add 'download'
hooks.add 'command'

server = http.createServer hooks.dispatch

server.listen(data.http_port, data.host);
