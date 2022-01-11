require('dotenv').config()

express = require 'express'
helmet = require 'helmet'

port = process.env.PORT
console.log '############ port'
console.log port

###
db = require('./models');
db.sequelize.sync()###

app = express()
app.use express.json()
app.use express.urlencoded(extended: true)
app.use helmet()

# Routes Definitions
app.get "/", (req, res) ->
  res.status(200).send "Funcionou, piá"

# Server Activation
app.listen port, () -> 
  console.log "Ouvindo http://localhost:#{port}"