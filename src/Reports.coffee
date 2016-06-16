path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
Table = require 'cli-table'
jade = require 'jade'
stylus = require 'stylus'
koutoSwiss = require 'kouto-swiss'
mdTable = require 'markdown-table'

createDir = (dirname) ->
  mkdirp.sync dirname if not fs.existsSync dirname

writeFile = (file, content) ->
  createDir path.dirname file
  fs.writeFile file, content, (err) ->
    if err
      console.log err
    else
      console.log 'File ' + file + ' created!'

printCli = (data, options) ->
  return printCliMd data if options.useMarkdown

  {authors, files, dates} = data

  authorsTable = new Table
    head: authors.head
    colWidths: authors.colWidths

  authorsTable.push.apply authorsTable, authors.data

  filesTable = new Table
    head: files.head
    colWidths: files.colWidths

  filesTable.push.apply filesTable, files.data

  datesTable = new Table
    head: dates.head
    colWidths: dates.colWidths

  datesTable.push.apply datesTable, dates.data

  console.log authorsTable.toString()
  console.log filesTable.toString()
  console.log datesTable.toString()

printCliMd = ({authors, files, dates}) ->
  console.log mdTable(authors), '\n'
  console.log mdTable(files), '\n'
  console.log mdTable dates

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
    data =
      authors:
        head: ['Author', 'Lines', 'Uncovered Lines', 'Coverage']
        colWidths: [50, 15, 15, 15]
        data: [].concat ([
          result.authors[author].author,
          result.authors[author].lines,
          result.authors[author].uncoveredLines,
          result.authors[author].coverage.toFixed(2) + "%"
        ] for author of result.authors)
      files:
        head: ['File', 'Lines', 'Uncovered Lines', 'Coverage']
        colWidths: [50, 15, 15, 15]
        data: [].concat ([
          file.filename,
          file.lines,
          file.uncoveredLines,
          file.coverage.toFixed(2) + "%"
        ] for file in result.files when file.coverage isnt 100)
      dates:
        head: ['Date', 'Lines', 'Uncovered Lines', 'Coverage']
        colWidths: [50, 15, 15, 15]
        data: [].concat ([
          (new Date(parseInt(dateString + "000"))).toDateString(),
          coverage.lines,
          coverage.uncoveredLines,
          if coverage.coverage then coverage.coverage.toFixed(2) + "%" else '100.00%'
        ] for dateString, coverage of result.dates)

    printCli data, options
