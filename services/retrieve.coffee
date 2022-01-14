db = require '../models'
Article = db.article
Launch = db.launch
Event = db.event
axios = require 'axios'
cron = require 'node-cron'
articleCtrl = require '../controllers/article-controller'
foreach = require '../utils/foreach'

axiosInstance = axios.create {
  baseURL: 'https://api.spaceflightnewsapi.net/v3/articles'
}

exports.all = () ->
  new Promise (accept, reject) ->
    perPage = 500
    db.sequelize.transaction( (tx) ->
      new Promise (accept, reject) ->
        axiosInstance.get('/count').then (countResponse) ->
          total = (countResponse.data - countResponse.data % perPage) / perPage
          get = (page) ->
            new Promise (accept, reject) ->
              offset = page * perPage
              url = "?_sort=id&_limit=#{perPage}&_start=#{offset}"
              axiosInstance.get(url).then (getArticlesResponse) ->
                articleCtrl.createAll(getArticlesResponse.data, tx).then () ->
                  accept()
                .catch (err) ->
                  reject err
              .catch (err) ->
                reject err
          foreach([0..total], get).then () ->
            accept()
          .catch (err) ->
            reject err
        .catch (err) ->
          reject err
    ).then () ->
      accept()
    .catch (err) ->
      reject err
      
exports.setCron = () ->
  cron.schedule '0 9 * * *', () ->
    getNew().then () ->
      console.log 'Executado com sucesso'
    .catch (err) ->
      console.log err

getNew = () ->
  new Promise (accept, reject) ->
    perPage = 500
    db.sequelize.transaction( (tx) ->
      new Promise (accept, reject) ->
        get = () ->
          new Promise (accept, reject) ->
            options = {
              order: [
                ['id', 'DESC']
              ]
              limit: 1
              transaction: tx
            }
            Article.findAll(options).then (articles) ->
              lastId = if articles[0] then articles[0].id else 0
              url = "?_sort=id&_limit=#{perPage}&id_gt=#{lastId}"
              axiosInstance.get(url).then (response) ->
                articleCtrl.createAll(response.data, tx).then () ->
                  accept(response.data.length or 0)
                .catch (err) ->
                  reject err
              .catch (err) ->
                reject err
            .catch (err) ->
              reject err

        getUntilApiReturnNothing = () ->
          get().then (articlesCount) ->
            if articlesCount > 0
              getUntilApiReturnNothing()
            else
              accept()
          .catch (err) ->
            reject err

        getUntilApiReturnNothing()

    ).then () ->
      accept()
    .catch (err) ->
      reject err