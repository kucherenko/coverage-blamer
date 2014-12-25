CoverageBlamer = require './CoverageBlamer'
Blamer = require 'blamer'
Coverage = require './Coverage'

options =
  coverage: new Coverage '/home/apk/workspace/lab/coverage-blamer/coverage/coverage.json'
  blamer: new Blamer()

coverageBlamer = new CoverageBlamer coverage, blamer, '/home/apk/workspace/lab/coverage-blamer/src'

coverageBlamer.blame().then (result) ->
  console.log result
