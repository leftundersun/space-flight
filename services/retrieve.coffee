db = require '../models'
Article = db.article
axios = require 'axios'
cron = require 'node-cron'
articleCtrl = require '../controllers/article-controller'
foreach = require '../utils/foreach'
logger = require '../utils/logger'

axiosInstance = axios.create {
  baseURL: 'https://api.spaceflightnewsapi.net/v3/articles'
}

setCron = () ->
  cron.schedule '0 9 * * *', () ->
    update().then () ->
      logger.info "Executada atualização diária de artigos"
    .catch (err) ->
      logger.error err

update = () ->
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

exports.setCron = setCron
exports.update = update