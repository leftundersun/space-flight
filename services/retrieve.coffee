db = require '../models'
Article = db.article
Launch = db.launch
Event = db.event
axios = require 'axios'
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
								saveData(getArticlesResponse.data, tx).then () ->
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

saveData = (articles, tx) ->
	new Promise (accept, reject) ->
		console.log '############## articles'
		console.log articles

		saveLaunch = (launch) ->
			new Promise (accept, reject) ->
				console.log '######### launch'
				console.log launch
				Launch.findOne(where: { id: launch.id }, transaction: tx).then (result) ->
					if not result
						Launch.create(launch, { transaction: tx }).then () ->
							accept()
						.catch (err) ->
							reject err
					else
						accept()

		saveEvent = (event) ->
			new Promise (accept, reject) ->
				console.log '############ event'
				console.log event
				#verify for existing one
				Event.findOne(where: { id: event.id }, transaction: tx).then (result) ->
					if not result
						Event.create(event, { transaction: tx }).then () ->
							accept()
						.catch (err) ->
							reject err
					else
						accept()

		saveArticle = (article) ->
			new Promise (accept, reject) ->
				console.log '############ article'
				console.log article
				foreach(article.launches, saveLaunch).then () ->

					foreach(article.events, saveEvent).then () ->

						Article.create(article, { transaction: tx }).then (savedArticle) ->
							launchesIds = Array.from article.launches, (launch) => launch.id
							savedArticle.addLaunches(launchesIds, { transaction: tx }).then () ->

								eventsIds = Array.from article.events, (event) => event.id
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

		foreach(articles, saveArticle).then () ->
			accept()
		.catch (err) ->
			reject err


exports.setCron = () ->
	return

getNew = () ->
	return