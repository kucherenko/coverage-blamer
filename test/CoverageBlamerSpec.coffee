_ = require 'lodash'
require "./_bootstrap"

describe "Coverage Blamer", ->
	sut = null
	options = null
	coverage = null
	blamer = null
	pathToSource = null
	blameData = null
	covObject = null

	beforeEach ->
		pathToSource = '/path/to/source'
		covObject = files: [{
				filename: 'file1',
				source: {"1": {"a": "test"}}
		}]
		blameData =
			"/path/to/source/file1":
				"1":
					"b": "test"

		coverage =
			toObject: env.stub().returns covObject

		blamer =
			blameByFile: env.stub().resolves blameData

		sut = require "#{sourcePath}CoverageBlamer"

	it "should blame code based on coverage report", ->
		cb = new sut coverage, blamer, pathToSource
		expected = files: [{
				filename: 'file1',
				source: {"1": {"a": "test", "b": "test"}}
		}]
		cb.blame().should.become expected
