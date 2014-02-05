data = {
    host: '127.0.0.1'
    command_port: 9001
    http_port: 8080

    password: 'foopass'

    file_path: __dirname + '/../storage/' # Must end in a slash
    max_size: 1024 * 1024              # Max size (in MB) this node can take before denying new transfers

    redis_port: 6379
    redis_host: '127.0.0.1'
    redis_options: {}
}

winston = require 'winston'
data.log = new (winston.Logger)({
    transports: [
        new (winston.transports.Console)({ json: false, timestamp: true })
        new winston.transports.File({ filename: __dirname + '/debug.log', json: false })
    ],
    exceptionHandlers: [
        new (winston.transports.Console)({ json: false, timestamp: true })
        new winston.transports.File({ filename: __dirname + '/exceptions.log', json: false })
    ],
    exitOnError: false
})

redis = require 'redis'
data.redis = redis.createClient(data.redis_port, data.redis_host, data.redis_options)
data.redis.on 'error', data.log.error

http = require 'http'
hooks = require './lib/hooks'

hooks.set data
hooks.add 'download'
# hooks.add 'command'

server = http.createServer hooks.dispatch

server.listen(data.http_port, data.host);

data.log.info '----------------------------------------'
data.log.info 'Booted HTTP server on ' + data.host + ':' + data.http_port
data.log.info 'Created by peet.io. Report bugs on github.'
data.log.info '----------------------------------------'