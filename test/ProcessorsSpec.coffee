
require "./_bootstrap"

describe "Processors", ->

  sut = null
  result = null
  dateTimestamp1 = null
  dateTimestamp2 = null

  beforeEach ->

    dateString1 = "2014-10-15T12:33:31.675393Z"
    dateString2 = "2014-10-16T12:35:31.675393Z"

    dateTimestamp1 = (new Date (new Date dateString1).toLocaleDateString()).getTime() / 1000
    dateTimestamp2 = (new Date (new Date dateString2).toLocaleDateString()).getTime() / 1000

    result = files: [
      {
        filename: 'file1',
        source:
          "1":
            "rev": "rev",
            "author": "author",
            "date": dateString1,
            "line": "1"
            "coverage": 0
          "2":
            "rev": "rev",
            "author": "author",
            "date": dateString1,
            "line": "2"
            "coverage": 1
      } ,
      {
        filename: 'file2',
        source:
          "1":
            "rev": "rev",
            "author": "author",
            "date": dateString1,
            "line": "1"
            "coverage": 0
          "2":
            "rev": "rev1",
            "author": "author1",
            "date": dateString2,
            "line": "2"
            "coverage": 1
          "3":
            "rev": "rev1",
            "author": "author1",
            "date": dateString2,
            "line": "3"
            "coverage": 1
      }
    ]

    sut = require "#{sourcePath}Processors"

  it "should group code by authors", ->
    sut.process result

    result.authors.should.deep.equal
      "author":
        "author": "author"
        "coverage": 33.33333333333334
        "lines": 3
        "uncoveredLines": 2
        "dates":
          "#{dateTimestamp1}":
            "coverage": 33.33333333333334
            "lines": 3
            "uncoveredLines": 2
      "author1":
        "author": "author1"
        "coverage": 100
        "lines": 2
        "uncoveredLines": 0
        "dates":
          "#{dateTimestamp2}":
            "coverage": 100
            "lines": 2
            "uncoveredLines": 0

  it "should group code by dates", ->
    sut.process result

    result.dates.should.deep.equal
      "#{dateTimestamp1}":
        "coverage": 33.33333333333334
        "lines": 3
        "uncoveredLines": 2
      "#{dateTimestamp2}":
        "coverage": 100
        "lines": 2
        "uncoveredLines": 0
