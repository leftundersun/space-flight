logger = require './logger'

basicResponse = (res, payload) ->
  res
    .status payload.status
    .json payload

sendError = (req, res, err) ->
  if err.status and err.message

    logger.info "#{req.method} #{req.originalUrl} #{err.status}: #{err.message}"

    basicResponse res, {
      status: err.status
      message: err.message
    }
  else

    logger.error "#{req.method} #{req.originalUrl} 500: #{err.toString()}"

    basicResponse res, {
      status: 500
      message: 'Erro interno do servidor'
    }

sendSuccess = (req, res, status, message) ->
  logger.info "#{req.method} #{req.originalUrl} #{status}"
  basicResponse res, {
    status: status
    message: message
  }

sendData = (req, res, status, data) ->
  logger.info "#{req.method} #{req.originalUrl} #{status}"
  basicResponse res, {
    status: status
    data: data
  }

exports.sendError = sendError
exports.sendSuccess = sendSuccess
exports.sendData = sendData