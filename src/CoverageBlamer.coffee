Promise = require "bluebird"
_ = require "lodash"

class CoverageBlamer

	constructor: (@coverage, @blamer) ->

	anotate: ->
		files = @coverage.getCoverageByFiles()

		Promise.all(@blamer.blameByFile file for file in Object.keys files).then (results) ->
			blame = {}
			_.extend blame, res for res in results
			return coverage: files, blame: blame

module.exports = CoverageBlamer
