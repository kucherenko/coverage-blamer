
require "./_bootstrap"

describe "Coverage", ->
	sut = null
	json = null

	beforeEach ->
		json = env.stub()
		sut = require "#{sourcePath}Coverage"

	it "should get coverage by files as Object", ->
		coverage = new sut '/path/to/coverage.json'
		env.stub(coverage.coverager, 'read')
		env.stub(coverage.coverager, 'toObject').returns 'coverage'
		coverage.toObject().should.equal 'coverage'
