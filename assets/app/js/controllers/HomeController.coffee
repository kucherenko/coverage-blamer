angular.module("app").controller 'HomeController', ($scope, $location, $resource, $rootScope, $timeout) ->
  cal = new CalHeatMap()
  $scope.fullCoverage =
    series: []
  $scope.authorsBar =
    series: []
    labels: []
  $scope.filesBar =
    series: []
    labels: []
  $scope.fullCoverageOptions =
    donut: yes

  $resource('coverage-blamer.json').get (coverage)->
    cov = parseFloat coverage.coverage.toFixed 2
    unCov = parseFloat (100 - cov).toFixed 2
    $scope.fullCoverage =
      series: [cov, unCov]
    uncovByDate = {}
    _.forIn coverage.dates, (value, key) ->
      uncovByDate[key] = value.uncoveredLines
    $scope.authors = _.values coverage.authors
    $scope.files = coverage.files

    $scope.authorsBar =
      labels: Object.keys(coverage.authors)
      series: [
        _.map $scope.authors, (author) -> author.lines
        _.map $scope.authors, (author) -> author.uncoveredLines
      ]

    $scope.filesBar =
      labels: _.map coverage.files, (file)-> file.filename
      series: [
        _.map coverage.files, (file)-> 100 - file.uncoveredLines / file.lines
      ]

    cal.init
      domain: 'month'
      subDomain: 'x_day'
      cellSize: 15
      range: 6
      verticalOrientation: yes
      colLimit: 1
      domainGutter: 5
      itemName: 'item'
      data: uncovByDate
      legend: [0, 1, 2, 3]
      previousSelector: "#previous",
      nextSelector: "#next"
      start: new Date(1000 * Object.keys(coverage.dates)[0])
      legendHorizontalPosition: "right",
      legendColors:
        empty: "#ededed"
        min: "#fefefe"
        max: "#f20013"
