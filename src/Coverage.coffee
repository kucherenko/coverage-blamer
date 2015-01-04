path = require 'path'
fs = require 'fs'
json = require './coverage/json'
lcov = require './coverage/lcov'


class Coverage

  constructor: (file) ->
    @file = fs.realpathSync file
    @coverager = null
    @initialize()

  initialize: ->
    ext = path.extname(@file)
    if ext is '.json'
      @coverager = new json @file, @options
    else if ext is '.lcov'
      @coverager = new lcov @file, @options

  toObject: ->
    if @coverager
      @coverager.read()
      @coverager.toObject()

module.exports = Coverage
