
require "./_bootstrap"
proxyquire = require("proxyquire").noPreserveCache()
JSONCoverage = require "#{sourcePath}coverage/json"
LCOVCoverage = require "#{sourcePath}coverage/lcov"

describe "Coverage", ->
  sut = null
  json = null
  fs = null

  beforeEach ->
    fs =
      realpathSync: env.stub()
    json = env.stub()
    sut = proxyquire("#{sourcePath}Coverage", {fs: fs})

  it "should get coverage by files as Object", ->
    file = '/path/to/coverage.json'
    fs.realpathSync.returns file
    coverage = new sut file
    env.stub(coverage.coverager, 'read')
    env.stub(coverage.coverager, 'toObject').returns 'coverage'
    coverage.toObject().should.equal 'coverage'

  it "should get coverager for json", ->
    file = '/path/to/coverage.json'
    fs.realpathSync.returns file
    coverage = new sut file
    coverage.coverager.should.be.an.instanceof JSONCoverage

  it.skip "should get coverager for lcov", ->
    file = '/path/to/coverage.lcov'
    fs.realpathSync.returns file
    coverage = new sut file
    coverage.coverager.should.be.an.instanceof LCOVCoverage
