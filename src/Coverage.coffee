path = require 'path'

json = require './coverage/json'
lcov = require './coverage/lcov'


class Coverage

  constructor: (file) ->
    @file = file
    @coverager = null
    @initialize()

  initialize: ->
    ext = path.extname(@file)
    if ext is '.json'
      @coverager = new json @file
    else if ext is '.lcov'
      @coverager = new lcov @file

  toObject: ->
    if @coverager
      @coverager.read()
      @coverager.toObject()

module.exports = Coverage
