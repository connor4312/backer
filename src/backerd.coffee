app = require './lib/express'

require('./routes/command-publicize')(app)
require('./routes/command-receive')(app)
require('./routes/command-remove')(app)
require('./routes/command-send')(app)
require('./routes/command-size')(app)
require('./routes/download')(app)

config = require './config'

app.listen config.http_port, config.host