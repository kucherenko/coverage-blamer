angular.module("app").controller 'HomeController', ($scope, $location, $resource, $rootScope, $timeout) ->
  cal = new CalHeatMap()
  fullCoverageDonut = Morris.Donut
    element: 'full-coverage'
    resize: yes
    colors: ['#c7d699','#FF0700']
    data: [
      {label: 'Covered', value:1}
      {label: 'Uncovered', value:0}
    ]

  authorsBar = Morris.Bar
    element: 'bar-authors',
    barColors: ['#c7d699','#FF0700']
    data: [],
    xkey: 'y',
    ykeys: ['a', 'b'],
    labels: ['Total lines', 'Uncovered lines']

  filesBar = Morris.Bar
    element: 'bar-files',
    barColors: ['#c7d699','#FF0700']
    data: [],
    xkey: 'y',
    ykeys: ['a', 'b'],
    labels: ['Total lines', 'Uncovered lines']

  $resource('coverage-blamer.json').get (coverage)->
    cov = parseFloat coverage.coverage.toFixed 2
    unCov = parseFloat (100 - cov).toFixed 2
    fullCoverageDonut.setData [
      {label: 'Covered', value:cov}
      {label: 'Uncovered', value:unCov}
    ]

    uncovByDate = {}
    _.forIn coverage.dates, (value, key) ->
      uncovByDate[key] = value.uncoveredLines
    $scope.authors = _.values coverage.authors
    $scope.files = coverage.files

    authorsBar.setData _.map coverage.authors, (author) -> y:author.author, a: author.lines, b: author.uncoveredLines
    filesBar.setData _.map coverage.files, (file) -> y:file.filename, a: file.lines, b: file.uncoveredLines

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
