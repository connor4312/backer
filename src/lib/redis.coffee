log = require './logging'
config = require '../config'

redis = require 'redis'
r = redis.createClient(config.redis_port, config.redis_host, config.redis_options)
r.on 'error', log.error

module.exports = r