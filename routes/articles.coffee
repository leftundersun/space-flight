module.exports = (app) ->
  
  articles = require('express').Router()

  articles.get '/', (req, res) ->
    res.status 501

  articles.get '/:id', (req, res) ->
    res.status 501

  articles.post '/', (req, res) ->
    res.status 501

  articles.put '/:id', (req, res) ->
    res.status 501

  articles.delete '/:id', (req, res) ->
    res.status 501

  app.use '/api/articles', articles
  return