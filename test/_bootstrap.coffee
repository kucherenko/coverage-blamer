
if process.env["COVERAGE"]
  console.log "COVERAGE mode is on"
  global.sourcePath = __dirname + "/../.tmp/"
else
  global.sourcePath = __dirname + "/../src/"

chai = require("chai")
sinon = require("sinon")
proxyquire = require("proxyquire")

chai.use require("sinon-chai")
chai.should()

beforeEach ->
  global.chai = chai
  global.sinon = sinon
  global.proxyquire = proxyquire
  global.env = sinon.sandbox.create()

afterEach ->
  global.env.restore()
