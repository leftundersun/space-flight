require('dotenv').config()

express = require 'express'
helmet = require 'helmet'

port = process.env.PORT

db = require('./models');
db.sequelize.sync()

app = express()
app.use express.json()
app.use express.urlencoded(extended: true)
app.use helmet()

# Routes Definitions
app.get "/", (req, res) ->
  res.status(200).send "Back-end Challenge 2021 🏅 - Space Flight News"

require('./routes/articles') app

# Set cron
require('./services/retrieve').setCron()

# Server Activation
app.listen port, () -> 
  console.log "Ouvindo http://localhost:#{port}"