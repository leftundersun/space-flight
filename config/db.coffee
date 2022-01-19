require('dotenv').config()
module.exports = 
  development: {
    username: process.env.DB_USER or 'root'
    password: process.env.DB_PASS or 'root'
    database: process.env.DB_NAME or 'space_flight'
    host: process.env.DB_HOST or '172.20.0.1'
    port: process.env.DB_PORT or '3308'
    dialect: process.env.DB_DLCT or 'mysql'
  }
  test: {
    username: process.env.DB_USER or 'root'
    password: process.env.DB_PASS or 'root'
    database: process.env.DB_NAME or 'space_flight'
    host: process.env.DB_HOST or '172.20.0.1'
    port: process.env.DB_PORT or '3308'
    dialect: process.env.DB_DLCT or 'mysql'
  }
  production: {
    username: process.env.DB_USER or 'root'
    password: process.env.DB_PASS or 'root'
    database: process.env.DB_NAME or 'space_flight'
    host: process.env.DB_HOST or '172.20.0.1'
    port: process.env.DB_PORT or '3308'
    dialect: process.env.DB_DLCT or 'mysql'
  }