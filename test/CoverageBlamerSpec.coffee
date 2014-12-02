
require "./_bootstrap"

describe "Coverage Blamer", ->
	sut = null
	options = null
	coverage = null
	blamer = null

	beforeEach ->
		coverage = 
			getCoverageByFiles: env.stub().returns 
				'file1': {} 
				'file2': {}
		blamer = 
			blameByFile: env.stub()
		sut = require "#{sourcePath}CoverageBlamer"
		

	it "should blame code based on coverage report", ->
		cb = new sut coverage, blamer
		cb.anotate()
		blamer.blameByFile.should.have.been.calledWith 'file1'
		blamer.blameByFile.should.have.been.calledWith 'file2'

		
		