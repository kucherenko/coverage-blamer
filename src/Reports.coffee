fs = require 'fs'

module.exports =
  json: (result, options) ->
    if options.report_file
      fs.writeFile options.report_file, JSON.stringify result, (err) ->
        console.log err if err
