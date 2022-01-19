articleCtrl = require '../controllers/article-controller'
writter = require '../utils/writter'

module.exports = (app) ->
  
  articles = require('express').Router()

  articles.get '/', (req, res) ->
    articleCtrl.findAll(req.query.page).then (articles) ->
      writter.sendData req, res, 200, articles
    .catch (err) ->
      writter.sendError req, res, err

  articles.get '/:id', (req, res) ->
    articleCtrl.findOne(req.params.id).then (article) ->
      writter.sendData req, res, 200, article
    .catch (err) ->
      writter.sendError req, res, err

  articles.post '/', (req, res) ->
    articleCtrl.create(req.body).then () ->
      writter.sendSuccess req, res, 201, "Criado com sucesso"
    .catch (err) ->
      writter.sendError req, res, err

  articles.put '/:id', (req, res) ->
    articleCtrl.edit(req.body, req.params.id).then () ->
      writter.sendSuccess req, res, 200, "Atualizado com sucesso"
    .catch (err) ->
      writter.sendError req, res, err

  articles.delete '/:id', (req, res) ->
    articleCtrl.delete(req.params.id).then () ->
      writter.sendSuccess req, res, 200, "Excluído com sucesso"
    .catch (err) ->
      writter.sendError req, res, err

  app.use '/articles', articles