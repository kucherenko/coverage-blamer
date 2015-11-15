
require "./_bootstrap"

describe "Reports", ->

  sut = null

  beforeEach ->
    sut = require "#{sourcePath}Reports"

  it 'should generate cli report', ->

    report =
      authors:[]
      dates:[]
      files:[]

    env.stub console, 'log'

    sut.cli(report)

    console.log.should.have.been.called