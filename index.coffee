require('dotenv').config()

express = require 'express'
helmet = require 'helmet'
morgan = require 'morgan'

port = process.env.PORT

app = express()
app.use express.json()
app.use express.urlencoded(extended: true)
app.use helmet()
app.use morgan('tiny')

# Routes Definitions
app.get "/", (req, res) ->
  res.status(200).send "Back-end Challenge 2021 🏅 - Space Flight News"

require('./routes/route-articles') app

# Set cron
require('./services/retrieve').setCron()

# Server Activation
app.listen port, () -> 
  console.log "Ouvindo http://localhost:#{port}"