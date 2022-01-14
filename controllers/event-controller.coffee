db = require '../models'
Event = db.event

exports.create = (data, tx) ->
	new Promise (accept, reject) ->
		Event.findOne(where: { id: data.id }, transaction: tx).then (result) ->
			if not result
				Event.create(data, { transaction: tx }).then () ->
					accept()
				.catch (err) ->
					reject err
			else
				accept()