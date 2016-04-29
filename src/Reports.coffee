fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
table = require 'markdown-table'

createOutputDir = (options) ->
  mkdirp.sync options.output if not fs.existsSync options.output

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
    authorsTable = [[
        'Author'
        'Lines'
        'Uncovered Lines'
        'Coverage'
      ]]

    filesTable = [[
        'File'
        'Lines'
        'Uncovered Lines'
        'Coverage'
      ]]

    datesTable = [[
        'Date'
        'Lines'
        'Uncovered Lines'
        'Coverage'
      ]]

    authorsTable.push ([
      result.authors[author].author,
      result.authors[author].lines,
      result.authors[author].uncoveredLines,
      result.authors[author].coverage + "%"
    ] for author of result.authors)...

    filesTable.push ([
      path.relative(options.src, file.filename),
      file.lines,
      file.uncoveredLines,
      file.coverage + "%"
    ] for file in result.files when file.coverage isnt 100)...

    datesTable.push ([
      (new Date(parseInt(dateString + "000"))).toDateString(),
      coverage.lines,
      coverage.uncoveredLines,
      coverage.coverage + "%"
    ] for dateString, coverage of result.dates)...

    console.log table(authorsTable), '\n'
    console.log table(filesTable), '\n'
    console.log table datesTable
