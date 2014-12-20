
require "./_bootstrap"

proxyquire = require("proxyquire")

describe "Coverage", ->
	sut = null
	json = null

	beforeEach ->
		json = env.stub()
		sut = proxyquire "#{sourcePath}Coverage", {
			'../coverage/json': 'zzz'
		}

	it "should get coverage by files", ->
		cb = new sut '/path/to/coverage.json'
		cb.anotate()
		json.should.have.been.calledWith '/path/to/coverage.json'
