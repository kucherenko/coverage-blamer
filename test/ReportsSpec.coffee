require "./_bootstrap"

describe "Reports", ->
  sut = null

  beforeEach ->
    sut = require "#{sourcePath}Reports"

  it 'should generate cli report', ->
    report =
      authors: []
      dates: []
      files: []

    options =
      useMarkdown: false

    env.stub console, 'log'

    sut.cli(report, options)

    console.log.should.have.been.calledThrice

  it 'should generate cli report using markdown when defined', ->
    report =
      authors: []
      dates: []
      files: []

    options =
      useMarkdown: true

    env.stub console, 'log'

    sut.cli(report, options)

    console.log.should.have.been.calledThrice
    console.log.should.have.been.calledWith(sinon.match.string, '\n')
