db = require '../models'
Launch = db.launch

create = (data, tx) ->
  new Promise (accept, reject) ->
    Launch.findOne(where: { id: data.id }, transaction: tx).then (result) ->
      if not result
        Launch.create(data, { transaction: tx }).then () ->
          accept()
        .catch (err) ->
          reject err
      else
        accept()
    .catch (err) ->
      reject err

edit = (data, id, tx) ->
  new Promise (accept, reject) ->
    Launch.findOne(where: { id: id }, transaction: tx).then (result) ->
      if not result
        create(data, tx).then () ->
          accept()
        .catch (err) ->
          reject err
      else
        delete data.id
        Launch.update(data, { where: { id: id }, transaction: tx }).then () ->
          accept()
        .catch (err) ->
          reject err
    .catch (err) ->
      reject err


exports.create = create
exports.edit = edit