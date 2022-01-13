'use strict'
fs = require('fs')
path = require('path')
Sequelize = require('sequelize')
basename = path.basename(__filename)
env = process.env.NODE_ENV or 'development'
config = require(__dirname + '/../config/db.js')[env]
db = {}
sequelize = undefined

if config.use_env_variable
  sequelize = new Sequelize(process.env[config.use_env_variable], config)
else
  sequelize = new Sequelize(config.database, config.username, config.password, config)

fs.readdirSync(__dirname).filter((file) ->
  file.indexOf('.') != 0 and file != basename and file.slice(-3) == '.js'
).forEach (file) ->
  model = require(path.join(__dirname, file))(sequelize, Sequelize.DataTypes)
  db[model.name] = model

Object.keys(db).forEach (modelName) ->
  if db[modelName].associate
    db[modelName].associate db

db.article.belongsToMany( db.launch, through: 'article_launches' )
db.launch.belongsToMany( db.article, through: 'article_launches' )
db.article.belongsToMany( db.event, through: 'article_events' )
db.event.belongsToMany( db.article, through: 'article_events' )

db.sequelize = sequelize
db.Sequelize = Sequelize
module.exports = db