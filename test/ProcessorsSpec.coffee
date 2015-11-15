
require "./_bootstrap"

describe "Processors", ->

  sut = null
  result = null

  beforeEach ->
    json = env.stub()

    result = files: [
      {
        filename: 'file1',
        source:
          "1":
            "rev": "rev",
            "author": "author",
            "date": "2014-10-15T12:33:31.675393Z",
            "line": "1"
            "coverage": 0
          "2":
            "rev": "rev",
            "author": "author",
            "date": "2014-10-15T12:33:31.675393Z",
            "line": "2"
            "coverage": 1
      } ,
      {
        filename: 'file2',
        source:
          "1":
            "rev": "rev",
            "author": "author",
            "date": "2014-10-15T12:33:31.675393Z",
            "line": "1"
            "coverage": 0
          "2":
            "rev": "rev1",
            "author": "author1",
            "date": "2014-10-16T12:35:31.675393Z",
            "line": "2"
            "coverage": 1
          "3":
            "rev": "rev1",
            "author": "author1",
            "date": "2014-10-16T12:35:31.675393Z",
            "line": "3"
            "coverage": 1
      }
    ]

    sut = require "#{sourcePath}Processors"

  it "should group code by authors", ->
    sut.process result

    result.authors.should.deep.equal
      "AUTHOR":
        "author": "author"
        "coverage": 33.33333333333334
        "lines": 3
        "uncoveredLines": 2
        "dates":
          "1413320401":
            "lines": 3
            "uncoveredLines": 2
      "AUTHOR1":
        "author": "author1"
        "coverage": 100
        "lines": 2
        "uncoveredLines": 0
        "dates":
          "1413406801":
            "lines": 2
            "uncoveredLines": 0

  it "should group code by dates", ->
    sut.process result

    result.dates.should.deep.equal
      "1413320401":
        "coverage": 33.33333333333334
        "lines": 3
        "uncoveredLines": 2
      "1413406801":
        "coverage": 100
        "lines": 2
        "uncoveredLines": 0
