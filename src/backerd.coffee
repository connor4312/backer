app = require './lib/express'
config = require './config'

app.listen config.http_port, config.host