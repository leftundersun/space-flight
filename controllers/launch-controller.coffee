db = require '../models'
Launch = db.launch

exports.create = (data, tx) ->
	new Promise (accept, reject) ->
		Launch.findOne(where: { id: data.id }, transaction: tx).then (result) ->
			if not result
				Launch.create(data, { transaction: tx }).then () ->
					accept()
				.catch (err) ->
					reject err
			else
				accept()