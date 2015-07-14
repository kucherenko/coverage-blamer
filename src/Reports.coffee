fs = require 'fs'
mkdirp = require 'mkdirp'
Table = require 'cli-table'

createOutputDir = (options) ->
  mkdirp.sync options.output if not fs.existsSync options.output

sortByCoverage = (a, b) ->
  return 1 if a.coverage > b.coverage
  return -1 if a.coverage < b.coverage
  return 0

module.exports =
  html: (result, options) ->
    createOutputDir options

  json: (result, options) ->
    createOutputDir options
    fs.writeFile options.output + '/coverage-blamer.json', JSON.stringify(result), (err) ->
      if err
        console.log err
      else
        console.log 'File ' + options.output + '/coverage-blamer.json created!'

  cli: (result, options) ->
    result.files.sort sortByCoverage
    # result.authors.sort sortByCoverage

    keysSorted = Object.keys(result.authors).sort (a, b) ->
      return 1 if result.authors[a].coverage > result.authors[b].coverage
      return -1 if result.authors[a].coverage < result.authors[b].coverage
      return 0

    authors = {}
    authors[author] = result.authors[author] for author in keysSorted

    table = new Table(
      head: [
        'Author'
        'Lines'
        'Uncovered Lines'
        'Coverage'
      ]
      colWidths: [
        300
        100
        100
        100
      ])
    # table is an Array, so you can `push`, `unshift`, `splice` and friendsuncoveredLines
    table.push authors[author].author, authors[author].lines, authors[author].uncoveredLines, authors[author].coverage + "%" for author in authors
    console.log authors
    console.log table.toString()
