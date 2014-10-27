if (process.env['COVERAGE']) {
    console.log('COVERAGE mode is on');
    global.sourcePath = __dirname + '/../.tmp/';
} else {
    global.sourcePath = __dirname + '/../src/'
}

var chai = require('chai');
var sinon = require('sinon');
var proxyquire =  require('proxyquire')

chai.use(require('sinon-chai'));
chai.should();

beforeEach(function () {
    global.chai = chai;
    global.proxyquire = proxyquire;
    global.sinon = sinon;
    global.env = sinon.sandbox.create();
});

afterEach(function () {
    global.env.restore();
});
