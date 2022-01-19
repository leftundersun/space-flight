winston = require 'winston'
moment = require 'moment'

createLogger = winston.createLogger
format = winston.format
transports = winston.transports

today = moment()
todayLogFile = "#{ process.env.LOG_DIR }/#{ today.year() }/#{ parseInt( today.month() ) + 1 }/#{ today.date() }.log"

logger = createLogger {
  format: format.combine format.timestamp(), format.json()
  transports: [
    new transports.File {filename: todayLogFile}
  ]
}

module.exports = logger