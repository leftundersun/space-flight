db = require '../models'
Article = db.article
Launch = db.launch
Event = db.event
launchCtrl = require './launch-controller'
eventCtrl = require './event-controller'
foreach = require '../utils/foreach'

findAll = (page, tx=null) ->
  new Promise (accept, reject) ->
    perPage = 500

    options = {
      limit: perPage
      offset: ( (parseInt(page) or 1) - 1) * perPage
      order: [
        ['id', 'ASC']
      ]
      include: [Launch, Event]
    }

    if tx
      options.transaction = tx

    Article.findAll(options).then (articles) ->
      accept articles
    .catch (err) ->
      reject err

findOne = (id, tx=null) ->
  new Promise (accept, reject) ->

    options = {
      where: {
        id: id
      }
      include: [Launch, Event]
    }

    if tx
      options.transaction = tx

    Article.findOne(options).then (article) ->
      if article
        accept article
      else
        reject {
          status: 404,
          message: "O artigo solicitado não foi encontrado"
        }
    .catch (err) ->
      reject err

create = (data, tx=null) ->
  new Promise (accept, reject) ->
    if not tx
      db.sequelize.transaction( (tx) ->
        new Promise (accept, reject) ->
          create(data, tx).then () ->
            accept()
          .catch (err) ->
            reject err
      ).then () ->
        accept()
      .catch (err) ->
        reject err
    else 
      foreach(data.launches or [], (launch) ->
        new Promise (accept, reject) ->
          launchCtrl.create(launch, tx).then () ->
            accept()
          .catch (err) ->
            reject err
      ).then () ->

        foreach(data.events or [], (event) ->
          new Promise (accept, reject) ->
            eventCtrl.create(event, tx).then () ->
              accept()
            .catch (err) ->
              reject err
        ).then () ->

          Article.create(data, { transaction: tx }).then (savedArticle) ->
            
            launchesIds = Array.from data.launches, (launch) => launch.id
            savedArticle.addLaunches(launchesIds, { transaction: tx }).then () ->

              eventsIds = Array.from data.events, (event) => event.id
              savedArticle.addEvents(eventsIds, { transaction: tx }).then () ->

                accept()

              .catch (err) ->
                reject err
            .catch (err) ->
              reject err
          .catch (err) ->
            reject err
        .catch (err) ->
          reject err
      .catch (err) ->
        reject err

createAll = (articles, tx) ->
  new Promise (accept, reject) ->
    foreach(articles, (article) ->
      new Promise (accept, reject) ->
        create(article, tx).then () ->
          accept()
        .catch (err) ->
          reject err
    ).then () ->
      accept()
    .catch (err) ->
      reject err

edit = (data, id, tx=null) ->
  new Promise (accept, reject) ->
    if not tx
      db.sequelize.transaction( (tx) ->
        new Promise (accept, reject) ->
          edit(data, id, tx).then () ->
            accept()
          .catch (err) ->
            reject err
      ).then () ->
        accept()
      .catch (err) ->
        reject err
    else
      findOne(id, tx).then (article) ->
        foreach(data.launches or [], (launch) ->
          new Promise (accept, reject) ->
            launchCtrl.create(launch, tx).then () ->
              accept()
            .catch (err) ->
              reject err
        ).then () ->

          foreach(data.events or [], (event) ->
            new Promise (accept, reject) ->
              eventCtrl.create(event, tx).then () ->
                accept()
              .catch (err) ->
                reject err
          ).then () ->

            delete data.id
            console.log '########## data'
            console.log data
            Article.update(data, { where: { id: id }, transaction: tx }).then () ->
              
              updateArticleLaunches(article, data.launches, tx).then () ->

                updateArticleEvents(article, data.events, tx).then () ->

                  accept()

                .catch (err) ->
                  reject err
              .catch (err) ->
                reject err
            .catch (err) ->
              reject err
          .catch (err) ->
            reject err
        .catch (err) ->
          reject err
      .catch (err) ->
        reject err

updateArticleLaunches = (article, launches, tx) ->
  new Promise (accept, reject) ->
    launchesIds = Array.from launches or [], (launch) -> launch.id
    articleLaunches = Array.from article.launches, (launch) -> launch.id

    launchesToAdd = launchesIds.filter (launchId) -> !articleLaunches.includes(launchId)
    launchesToRemove = articleLaunches.filter (launchId) -> !launchesIds.includes(launchId)
    
    article.addLaunches(launchesToAdd, { transaction: tx }).then () ->
      article.removeLaunches(launchesToRemove, { transaction: tx }).then () ->
        accept()
      .catch (err) ->
        reject err
    .catch (err) ->
      reject err

updateArticleEvents = (article, events, tx) ->
  new Promise (accept, reject) ->
    eventsIds = Array.from events or [], (event) -> event.id
    articleEvents = Array.from article.events, (event) -> event.id

    eventsToAdd = eventsIds.filter (eventId) -> !articleEvents.includes(eventId)
    eventsToRemove = articleEvents.filter (eventId) -> !eventsIds.includes(eventId)

    article.addEvents(eventsToAdd, { transaction: tx }).then () ->
      article.removeEvents(eventsToRemove, { transaction: tx }).then () ->
        accept()
      .catch (err) ->
        reject err
    .catch (err) ->
      reject err

exclude = (id) ->
  new Promise (accept, reject) ->
    db.sequelize.transaction( (tx) ->
      new Promise (accept, reject) ->
        findOne(id, tx).then (article) ->
          
          articleEvents = Array.from article.events, (event) -> event.id
          article.removeEvents(articleEvents, { transaction: tx }).then () ->
          
            articleLaunches = Array.from article.launches, (launch) -> launch.id
            article.removeLaunches(articleLaunches, { transaction: tx }).then () ->

              article.destroy(transaction: tx).then () ->
                accept()
              .catch (err) ->
                reject err

            .catch (err) ->
              reject err
          .catch (err) ->
            reject err
        .catch (err) ->
          reject err
    ).then () ->
      accept()
    .catch (err) ->
      reject err


exports.findAll = findAll
exports.findOne = findOne
exports.create = create
exports.createAll = createAll
exports.edit = edit
exports.delete = exclude
