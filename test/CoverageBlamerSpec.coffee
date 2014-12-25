_ = require 'lodash'
require "./_bootstrap"

Blamer = require 'blamer'
Coverage = require "#{sourcePath}Coverage"

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
				source: {"1": {"a": "test"} }
		} ]
		blameData =
			"/path/to/source/file1":
				"1":
					"b": "test"

		coverage = new Coverage pathToSource
		env.stub(coverage, 'toObject').returns covObject

		blamer = env.stub(Blamer::,'blameByFile').resolves blameData

		sut = require "#{sourcePath}CoverageBlamer"

	it "should blame code based on coverage report", ->
		cb = new sut {
			coverage: coverage,
			blamer: blamer,
			src: pathToSource
		}
		expected = files: [{
				filename: 'file1',
				source: {"1": {"a": "test", "b": "test"} }
		} ]
		cb.blame().should.become expected

	describe "Initialize", ->
		options = null

		beforeEach ->
			options =
				coverage: '/path/to/coverage.json'
				blamer: 'git'
				src: '/path/to/source'

		it "should initialize coverage blamer with options", ->
			env.stub(sut::, 'init')
			cb = new sut options
			sut::init.should.have.been.calledWith options

		it "should create new coverage object if we don't have it yet", ->
			cb = new sut options
			cb.coverage.should.be.instanceof Coverage

		it "should create new blamer object if we don't have it yet", ->
			cb = new sut options
			cb.blamer.should.be.instanceof Blamer
