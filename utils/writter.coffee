exports.sendError = (res, err) ->
  if err.message
    res
      .status err.status or 500
      .send err.message
  else
    res.sendStatus err.status or 500