retrieve = require '../services/retrieve'

retrieve.all().then () ->
	console.log 'Articles saved with success'
.catch (err) ->
	console.log err