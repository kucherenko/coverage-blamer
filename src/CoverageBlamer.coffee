_ = require "lodash"
Promise = require "bluebird"
path = require 'path'

class CoverageBlamer

	constructor: (@coverage, @blamer, @src) ->

	blame: ->
		coverage = @coverage.toObject()
		blamePromisses = []
		coverageRegistry = {}

		for file in coverage.files
			coverageRegistry[file.filename] = file
			blamePromisses.push @blamer.blameByFile path.join(@src, file.filename)

		# Promise.all(blamePromisses).then (results) ->
		# 		console.log results

module.exports = CoverageBlamer
