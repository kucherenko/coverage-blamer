_ = require 'lodash'
require "./_bootstrap"

Blamer = require 'blamer'
Coverage = require "#{sourcePath}Coverage"
Processors = require "#{sourcePath}Processors"
Reports = require "#{sourcePath}Reports"

describe "Coverage Blamer", ->

  sut = null
  options = null
  coverage = null
  blamer = null
  pathToSource = null
  blameData = null
  covObject = null
  expected = null

  beforeEach ->
    pathToSource = '/path/to/source'
    blameData =
      "/path/to/source/file1":
        "1":
          "b": "test"
    covObject = files: [{
        filename: 'file1',
        source: {"1": {"a": "test"} }
    } ]
    expected = files: [{
        filename: 'file1',
        source: {"1": {"a": "test", "b": "test"} }
    } ]

    coverage = new Coverage pathToSource
    env.stub(coverage, 'toObject').returns covObject
    blamer = env.stub(Blamer::, 'blameByFile').resolves blameData

    sut = require "#{sourcePath}CoverageBlamer"

  it "should blame code based on coverage report", ->
    cb = new sut
      coverage: coverage,
      blamer: blamer,
      src: pathToSource
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

  describe 'Run', ->

    cb = null

    beforeEach ->
      cb = new sut
        coverage: coverage,
        blamer: blamer,
        src: pathToSource

    it "should run statictic processors after blame", (done) ->
      process = env.stub(sut::, 'process')
      cb.run().then ->
        process.should.have.been.calledWith expected
        done()

    it "should run report render after blame", (done) ->
      process = env.stub(sut::, 'process').returns "result"
      report = env.stub(sut::, 'report')
      cb.run().then ->
        report.should.have.been.calledWith "result"
        done()


  describe 'Process Statistic', ->
    result = null
    cb = null

    beforeEach ->
      cb = new sut
        coverage: coverage,
        blamer: blamer,
        src: pathToSource
      env.stub Processors
      result = 'test data'

    it 'should process statistic', ->
      cb.process result
      Processors.process.should.have.been.calledWith result, cb.options

  describe 'Generate Report', ->
    result = null
    cb = null

    beforeEach ->
      cb = new sut
        coverage: coverage,
        blamer: blamer,
        src: pathToSource
        dest: '/path/to/report'
      env.stub Reports
      result = test: "data"

    it 'should generate json', ->

      cb.report result
      Reports.json.should.have.been.calledWith result
