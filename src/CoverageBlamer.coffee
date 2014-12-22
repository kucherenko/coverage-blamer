_ = require "lodash"
Promise = require "bluebird"
path = require 'path'
jsonReporter = require './reporter/json'

class CoverageBlamer

	constructor: (@coverage, @blamer, @src) ->

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

module.exports = CoverageBlamer
