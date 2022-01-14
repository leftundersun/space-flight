db = require '../models'
Article = db.article
Launch = db.launch
Event = db.event
axios = require 'axios'
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
	return

getNew = () ->
	return