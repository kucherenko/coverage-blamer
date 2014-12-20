
require "./_bootstrap"

proxyquire = require("proxyquire")

describe "Coverage", ->
	sut = null
	json = null

	beforeEach ->
		json = env.stub()
		sut = require "#{sourcePath}Coverage"
		
	it "should get coverage by files", ->
		coverage = new sut '/path/to/coverage.json'
