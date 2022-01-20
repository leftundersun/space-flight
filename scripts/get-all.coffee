retrieve = require '../services/retrieve'
logger = require '../utils/logger'

retrieve.update().then () ->
  logger.info "Executada atualização dos artigos"
  process.exit()
.catch (err) ->
  logger.error "Erro ao atualizar os artigos: " + err
  process.exit(1)