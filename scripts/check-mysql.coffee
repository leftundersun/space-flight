require('dotenv').config()
mysql = require 'mysql2'
logger = require '../utils/logger'

checkConnection = () ->
  new Promise (accept, reject) ->
    check = () ->
      new Promise (accept, reject) ->
        connection = mysql.createConnection {
          host: process.env.DB_HOST
          port: process.env.DB_PORT
          user: process.env.DB_USER
          password: process.env.DB_PASS
        }
        connection.query 'SHOW DATABASES', (err, results, fields) ->
          accept err

    checkUntilItWorks = () ->
      check().then (err) ->
        if err
          setTimeout checkUntilItWorks, 5000
        else
          accept()
      .catch (err) ->
        reject err

    checkUntilItWorks()
      
checkConnection().then () ->
  logger.info "Conectado com sucesso ao banco de dados"
  process.exit()
.catch (err) ->
  logger.error "Erro ao conectar ao banco de dados: " + err
  process.exit(1)