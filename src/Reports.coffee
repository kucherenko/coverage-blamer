fs = require 'fs'
mkdirp = require 'mkdirp'

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
