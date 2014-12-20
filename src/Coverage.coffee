
path = require 'path'

json = require './coverage/json'



class Coverage

  constructor: (@file) ->

  anotate: ->
    console.log(json)
    if path.extname(@file) is '.json'
      json(@file)

module.exports = Coverage
