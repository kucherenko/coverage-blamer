path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
Table = require 'cli-table'
jade = require 'jade'
stylus = require 'stylus'
koutoSwiss = require 'kouto-swiss'

createDir = (dirname) ->
  mkdirp.sync dirname if not fs.existsSync dirname

writeFile = (file, content) ->
  createDir path.dirname file
  fs.writeFile file, content, (err) ->
    if err
      console.log err
    else
      console.log 'File ' + file + ' created!'

module.exports =
  html: (result, options) ->
    str = fs.readFileSync("#{__dirname}/assets/styles/main.styl", 'utf8')
    stylus(str)
      .set('filename', "#{__dirname}/assets/styles/main.styl")
      .use(koutoSwiss())
      .render((err, css) ->
        if not err
          writeFile("#{options.output}/css/main.css", css)
        else
          console.log err
      )

    writeFile "#{options.output}/index.html", jade.renderFile("#{__dirname}/assets/templates/index.jade", result)
    for author, coverage of result.authors
      writeFile(
        "#{options.output}/authors/#{author}.html"
        jade.renderFile("#{__dirname}/assets/templates/author.jade", result.authors[author])
      )
    for fileObject in result.files
      fileObject.name = fileObject.filename
      writeFile(
        "#{options.output}/files/#{fileObject.filename.replace(/\//g, '_')}.html"
        jade.renderFile("#{__dirname}/assets/templates/file.jade", fileObject)
      )
#   for date, coverage in result.authors
#      writeFile "#{options.output}/authors/#{author}.html", jade.renderFile("#{__dirname}/assets/templates/author.jade", result.authors[author])

  json: (result, options) ->
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
      result.authors[author].coverage.toFixed(2) + "%"
    ] for author of result.authors)...

    filesTable.push ([
      file.filename,
      file.lines,
      file.uncoveredLines,
      file.coverage.toFixed(2) + "%"
    ] for file in result.files when file.coverage isnt 100)...

    datesTable.push ([
      (new Date(parseInt(dateString + "000"))).toDateString(),
      coverage.lines,
      coverage.uncoveredLines,
      if coverage.coverage then coverage.coverage.toFixed(2) + "%" else '100.00%'
    ] for dateString, coverage of result.dates)...

    console.log authorsTable.toString()
    console.log filesTable.toString()
    console.log datesTable.toString()
