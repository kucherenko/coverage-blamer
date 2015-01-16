angular.module("app").config ($routeProvider, $locationProvider) ->

  # $locationProvider.html5Mode on

  $routeProvider.when "/",
    templateUrl: "home.html"
    controller: "HomeController"
