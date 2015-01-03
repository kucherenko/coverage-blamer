
if process.env["COVERAGE"]
  # console.log "COVERAGE mode is on"
  global.sourcePath = __dirname + "/../.tmp/"
else
  global.sourcePath = __dirname + "/../src/"

chai = require("chai")
sinon = require("sinon")

sinonAsPromised = require("sinon-as-promised")

chai.use require("sinon-chai")
chai.use require("chai-as-promised")

chai.should()

beforeEach ->
  global.chai = chai
  global.sinon = sinon
  global.env = sinon.sandbox.create()

afterEach ->
  global.env.restore()
