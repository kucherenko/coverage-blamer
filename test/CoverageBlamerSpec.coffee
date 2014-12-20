
require "./_bootstrap"

describe "Coverage Blamer", ->
	sut = null
	options = null
	coverage = null
	blamer = null

	beforeEach ->
		coverage =
			toObject: env.stub().returns
					files: [
						{filename: 'file1'}
						{filename: 'file2'}
					]
		blamer =
			blameByFile: env.stub().returns {then: env.stub()}

		sut = require "#{sourcePath}CoverageBlamer"

	it "should blame code based on coverage report", ->
		cb = new sut coverage, blamer
		cb.blame()
		blamer.blameByFile.should.have.been.calledWith 'file1'
		blamer.blameByFile.should.have.been.calledWith 'file2'
