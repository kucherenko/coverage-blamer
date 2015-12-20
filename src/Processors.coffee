_ = require 'lodash'

calculateCoverage = (object) ->
  object.coverage = 100 - (object.uncoveredLines / object.lines) * 100
  return object

prepareDate = (string) ->
  d = new Date string
  (new Date d.toLocaleDateString()).getTime() / 1000

sortByCoverage = (a, b) ->
  return 1 if a.coverage > b.coverage
  return -1 if a.coverage < b.coverage
  return 0


sortObjectByCoverage = (object) ->
  results = {}
  keysSorted = Object.keys(object).sort (a, b) ->
    return 1 if object[a].coverage > object[b].coverage
    return -1 if object[a].coverage < object[b].coverage
    return 0
  results[key] = object[key] for key in keysSorted
  results


normalizeAuthorName = (name)->
  name = name.replace /^\s*|\s*$/g, ''
  name = name.replace /\ /g, '_'
  name.toLowerCase()

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
  uncoveredLines = 0
  lines = 0
  for file in result.files
    file.lines = 0
    file.uncoveredLines = 0
    _.forOwn file.source, (line) ->
      if not line.date then return
      authorName = normalizeAuthorName line.author
      author = authors[authorName]
      date = prepareDate line.date
      console.log 'Date Error:', line.date if isNaN date
      return if isNaN date

      if not author
          author = getAuthorTemplate line.author, date
          authors[authorName] = author

      if not author.dates[date]
          author.dates[date] =
            "lines": 0
            "uncoveredLines": 0
      dates[date] = dates[date] ? _.clone author.dates[date]

      if line.coverage isnt ''
        lines++
        file.lines++
        author.lines++
        dates[date].lines++
        author.dates[date].lines++

      if line.coverage is 0
        uncoveredLines++
        file.uncoveredLines++
        dates[date].uncoveredLines++
        author.uncoveredLines++
        author.dates[date].uncoveredLines++

      author.dates[date] = calculateCoverage author.dates[date]
      dates[date] = calculateCoverage dates[date]
      author = calculateCoverage author

    file = calculateCoverage file

  result.dates = dates
  result.authors = sortObjectByCoverage authors
  result.files = result.files.sort sortByCoverage if result.files
  result.uncoveredLines = uncoveredLines
  result.lines = lines
  result = calculateCoverage result
  return result

module.exports =
  process: process
