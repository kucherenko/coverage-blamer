_ = require 'lodash'
class JSONCoverage

  constructor: (@file, @options) ->

  read: ->
    @content = require @file

  convertJSCoverageToJSON: (result) ->
    result.files = @content.files

  convertIstanbulToJSON: (result) ->
    result.files = _.chain(@content)
      .values()
      .map (file) ->
        "filename": file.path
        "source": _.transform file.s, (res, num, key) ->
          res[key] = "coverage": num
      .value()


  convert: ->
    result = {}
    result.row = @content if not @options?.disableRow
    if @content.instrumentation and @content.instrumentation.indexOf('jscoverage') isnt -1
      result.type = 'jscoverage'
      @convertJSCoverageToJSON result
    else
      result.type = 'istanbul'
      @convertIstanbulToJSON result
    result

  toObject: ->
    @convert()


module.exports = JSONCoverage
