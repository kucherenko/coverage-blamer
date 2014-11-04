
require "./_bootstrap"

describe "Coverage Blamer", ->
	sut = null

	beforeEach ->
		sut = require "#{sourcePath}CoverageBlamer"

	it "should generate coverage for", ->
		sut().should.equal "ololo"