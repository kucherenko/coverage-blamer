CoverageBlamer = require './CoverageBlamer'
Blamer = require 'blamer'
Coverage = require './Coverage'

blamer = new Blamer()
coverage = new Coverage '/home/apk/workspace/lab/coverage-blamer/coverage/coverage.json'

coverageBlamer = new CoverageBlamer coverage, blamer, '/home/apk/workspace/lab/coverage-blamer/src'

coverageBlamer.blame()
