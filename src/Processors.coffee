_ = require 'lodash'

prepareDate = (string) ->
  d = new Date string
  d.setHours(0)
  d.setMinutes(0)
  d.setSeconds(1)
  d.setMilliseconds(0)
  d.getTime() / 1000

getAuthorTemplate = (name, date) ->
  author =
    "author": name
    "lines": 0
    "uncoveredLines": 0
    "dates": {}
  author.dates[date] =
    "lines": 0
    "uncoveredLines": 0
  author


process = (result) ->
  authors = {}
  dates = {}
  for file in result.files
    _.forOwn file.source, (line) ->

      author = authors[line.author]
      date = prepareDate line.date

      if not author
          author = getAuthorTemplate line.author, date
          authors[line.author] = author

      dates[date] = dates[date] ? _.clone author.dates[date]
      author.lines++
      author.dates[date].lines++
      dates[date].lines++

      if line.coverage is 0
        author.uncoveredLines++
        author.dates[date].uncoveredLines++
        dates[date].uncoveredLines++

  result.dates = dates
  result.authors = authors

module.exports =
  process: process
