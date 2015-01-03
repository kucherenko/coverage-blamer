commander = require 'commander'
CoverageBlamer = require './CoverageBlamer'
Blamer = require 'blamer'
Coverage = require './Coverage'
package_info = require '../package.json'

fs = require 'fs'

commander
  .version(package_info.version)
  .option('-c, --coverage <path>', 'Path to coverage report')
  .option('-v, --vcs [type]', 'Version control system', 'git')
  .option('-s, --source <path>', 'Path to source folder')
  .option('-o, --output <path>', 'Path to output folder')
  .parse process.argv

options =
  coverage: new Coverage commander.coverage
  blamer: new Blamer commander.vcs
  output: commander.output
  src: commander.source

coverageBlamer = new CoverageBlamer options

coverageBlamer.run()
