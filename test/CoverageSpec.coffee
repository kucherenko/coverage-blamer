
require "./_bootstrap"

JSONCoverage = require "#{sourcePath}coverage/json"
LCOVCoverage = require "#{sourcePath}coverage/lcov"

describe "Coverage", ->
	sut = null
	json = null

	beforeEach ->
		json = env.stub()
		sut = require "#{sourcePath}Coverage"

	it "should get coverage by files as Object", ->

		coverage = new sut '/path/to/coverag.json'
		env.stub(coverage.coverager, 'read')
		env.stub(coverage.coverager, 'toObject').returns 'coverage'
		coverage.toObject().should.equal 'coverage'

	it "should get coverager for json", ->
		coverage = new sut '/path/to/coverag.json'
		coverage.coverager.should.be.an.instanceof JSONCoverage

	it "should get coverager for lcov", ->
		coverage = new sut '/path/to/coverage.lcov'
		coverage.coverager.should.be.an.instanceof LCOVCoverage
