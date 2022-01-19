retrieve = require '../services/retrieve'
logger = require '../utils/logger'

retrieve.update().then () ->
  message = "Executada atualização dos artigos"
  logger.info message
.catch (err) ->
  logger.error err