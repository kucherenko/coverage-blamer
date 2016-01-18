_ = require "lodash"
Promise = require "bluebird"
path = require 'path'
fs = require 'fs'

Blamer = require 'blamer'
Coverage = require './Coverage'
Processors = require "./Processors"
Reports = require "./Reports"

class CoverageBlamer

  constructor: (options) ->
    @init options

  init: (options) ->
    @options = options
    @src = options.src
    @coverage = options.coverage

    if options.blamer instanceof Blamer
      @blamer = options.blamer
    else
      @blamer = new Blamer options.blamer

  process: (result) ->
    Processors.process(result, @options)
    return result

  report: (result) ->
    Reports.cli result, @options
    # Reports.json result, @options
    # Reports.html result, @options

  blame: ->
    coverage = @coverage.toObject()

    blamePromises = []
    coverageRegistry = {}
    for file in coverage.files
      if fs.existsSync file.filename
        filePath = file.filename
      else
        filePath = path.join(@src, file.filename)
      coverageRegistry[filePath] = file
      blamePromises.push @blamer.blameByFile filePath

    Promise.all(blamePromises).then (results) ->
        for res in results
          fileName = Object.keys(res)[0]
          coverageRegistry[fileName].source = _.merge coverageRegistry[fileName].source, res[fileName]
        return coverage
      .catch ->
        console.log arguments

  run: ->
    @blame().then (results) =>
      @report @process results

module.exports = CoverageBlamer
