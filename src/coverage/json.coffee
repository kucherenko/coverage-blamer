
class JSONCoverage

  constructor: (@file) ->

  read: () ->
    @content = require @file

  toObject: ->
    @content


module.exports = JSONCoverage
