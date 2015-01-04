
require "../_bootstrap"

describe "JSON Coverager", ->
  sut = null

  beforeEach ->
    sut = require "#{sourcePath}coverage/json"
    env.stub sut::, 'read'

  it 'should set input data as row to result', ->
    cov = new sut '/path'
    cov.content = 'test'
    cov.toObject().should.have.property 'row', cov.content

  it 'should not set input data as row to result if we want to disable row', ->
    cov = new sut '/path', disableRow:true
    cov.content = 'test'
    cov.toObject().should.have.not.property 'row'

  describe 'JSCoverage', ->

    jscoverageReport = null
    JSONCoverager = null

    beforeEach ->
      jscoverageReport =
        instrumentation: 'node-jscoverage'
        files: [
          "filename": "Coverage.coffee",
          "source":
            "1":
              "coverage": 1
        ]

      JSONCoverager = new sut '/path'
      JSONCoverager.content = jscoverageReport

    it 'should understand data from JSCoverage format', ->
      JSONCoverager.toObject().should.have.property 'type', 'jscoverage'

    it 'should extract files from jscoverage report', ->
      JSONCoverager.toObject().should.have.property 'files', jscoverageReport.files

  describe 'Istanbul Coverage', ->

    coverageReport = null
    JSONCoverager = null

    beforeEach ->
      coverageReport =
        "/path/to/file.js":
          "path": "/path/to/file.js"
          "s":
            "1": 1

      JSONCoverager = new sut '/path'
      JSONCoverager.content = coverageReport

    it 'should understand data from Istanbul format', ->
      JSONCoverager.toObject().should.have.property 'type', 'istanbul'

    it 'should extract files from jscoverage report', ->
      JSONCoverager.toObject().files.should.deep.equal [
        "filename": "/path/to/file.js",
        "source":
          "1":
            "coverage": 1
      ]
