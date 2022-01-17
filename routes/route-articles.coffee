articleCtrl = require '../controllers/article-controller'
writter = require '../utils/writter'

module.exports = (app) ->
  
  articles = require('express').Router()

  articles.get '/', (req, res) ->
    articleCtrl.findAll(req.query.page).then (articles) ->
      res
        .status 200
        .json articles
    .catch (err) ->
      console.log err
      writter.sendError res, err

  articles.get '/:id', (req, res) ->
    articleCtrl.findOne(req.params.id).then (article) ->
      res
        .status 200
        .json article
    .catch (err) ->
      console.log err
      writter.sendError res, err

  articles.post '/', (req, res) ->
    console.log '########## req'
    console.log req
    console.log '########## req.body'
    console.log req.body
    articleCtrl.create(req.body).then () ->
      res.sendStatus 201
    .catch (err) ->
      console.log err
      writter.sendError res, err

  articles.put '/:id', (req, res) ->
    console.log '########## req'
    console.log req
    console.log '########## req.body'
    console.log req.body
    articleCtrl.edit(req.body, req.params.id).then () ->
      res.sendStatus 200
    .catch (err) ->
      console.log err
      writter.sendError res, err

  articles.delete '/:id', (req, res) ->
    articleCtrl.delete(req.params.id).then () ->
      res.sendStatus 200
    .catch (err) ->
      console.log err
      writter.sendError res, err

  app.use '/articles', articles