module.exports = (itens, funcao, callback=null) ->
  new Promise (accept, reject) ->
    exec = (index) ->
      item = itens[index]
      funcao(item).then (result) ->
        next = ->
          index++
          if index < itens.length
            exec(index)
          else
            accept()

        if callback != null
          callback(result).then ->
            next()
          .catch (err) ->
            reject err
        else
          next()
      .catch (err) ->
        reject err

    if itens.length > 0
      exec 0
    else
      accept()