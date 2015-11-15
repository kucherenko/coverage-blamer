
require "./_bootstrap"

describe "Reports", ->

  sut = null

  beforeEach ->
    sut = require "#{sourcePath}/Reports.coffee"