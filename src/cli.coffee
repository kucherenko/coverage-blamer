CoverageBlamer = require './CoverageBlamer'
Blamer = require 'blamer'
Coverage = require './Coverage'

options =
  coverage: new Coverage '/home/apk/workspace/lab/coverage-blamer/coverage/coverage.json'
  blamer: new Blamer()
  report_file: '/tmp/coverage-blamer.json'
  src: '/home/apk/workspace/lab/coverage-blamer/src/'

coverageBlamer = new CoverageBlamer options

coverageBlamer.blame().then (result) ->
  console.log result
