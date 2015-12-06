fs = require 'fs'
mkdirp = require 'mkdirp'
Table = require 'cli-table'
jade = require 'jade'

createOutputDir = (options) ->
  mkdirp.sync options.output if not fs.existsSync options.output

writeFile = (file, content) ->
  fs.writeFile file, content, (err) ->
    if err
      console.log err
    else
      console.log 'File ' + file + ' created!'

module.exports =
  html: (result, options) ->
    createOutputDir options
    writeFile "#{options.output}/index.html", jade.renderFile("#{__dirname}/assets/templates/index.jade", result)

  json: (result, options) ->
    createOutputDir options
    writeFile options.output + '/coverage-blamer.json', JSON.stringify(result)

  cli: (result, options) ->
    authorsTable = new Table
      head: ['Author', 'Lines', 'Uncovered Lines', 'Coverage']
      colWidths: [50, 15, 15, 15]

    filesTable = new Table
      head: ['File', 'Lines', 'Uncovered Lines', 'Coverage']
      colWidths: [50, 15, 15, 15]

    datesTable = new Table
      head: ['Date', 'Lines', 'Uncovered Lines', 'Coverage']
      colWidths: [50, 15, 15, 15]

    authorsTable.push ([
      result.authors[author].author,
      result.authors[author].lines,
      result.authors[author].uncoveredLines,
      result.authors[author].coverage + "%"
    ] for author of result.authors)...

    filesTable.push ([
      file.filename,
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

    console.log authorsTable.toString()
    console.log filesTable.toString()
    console.log datesTable.toString()
