_ = require "lodash"
Promise = require "bluebird"
path = require 'path'

Blamer = require 'blamer'
Coverage = require './Coverage'
Processors = require "./Processors"

class CoverageBlamer

  constructor: (options) ->
    @init options


  init: (options) ->
    @options = options
    @src = options.src
    if options.coverage instanceof Coverage
      @coverage = options.coverage
    else
      @coverage = new Coverage options.coverage

    if options.blamer instanceof Blamer
      @blamer = options.blamer
    else
      @blamer = new Blamer options.blamer

  process: (result) ->
    Processors.process(result, @options)
    return result

  report: (result) ->

  blame: ->
    coverage = @coverage.toObject()

    blamePromisses = []
    coverageRegistry = {}

    for file in coverage.files
      filePath = path.join(@src, file.filename)
      coverageRegistry[filePath] = file
      blamePromisses.push @blamer.blameByFile filePath

    Promise.all(blamePromisses).then (results) ->
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
