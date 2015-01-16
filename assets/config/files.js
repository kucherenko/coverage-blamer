/* Exports a function which returns an object that overrides the default &
 *   plugin file patterns (used widely through the app configuration)
 *
 * To see the default definitions for Lineman's file paths and globs, see:
 *
 *   - https://github.com/linemanjs/lineman/blob/master/config/files.coffee
 */
module.exports = function(lineman) {
  //Override file patterns here
  return {
    js: {
      vendor: [
        "vendor/bower/lodash/dist/lodash.js",
        "vendor/bower/jquery/dist/jquery.js",
        "vendor/bower/d3/d3.js",
        "vendor/bower/cal-heatmap/cal-heatmap.js",
        "vendor/bower/angular/angular.js",
        "vendor/bower/angular-animate/angular-animate.js",
        "vendor/bower/angular-cal-heatmap-directive/dist/1.3.0/calHeatmap.min.js",
        "vendor/bower/angular-resource/angular-resource.js",
        "vendor/bower/angular-route/angular-route.js",
        "vendor/bower/raphael/raphael.js",
        "vendor/bower/morris.js/morris.js",
        "vendor/bower/chart-angular-raphaeljs-morris/src/directives/chartangular.js",
        "vendor/bower/ng-table/ng-table.js",
        "vendor/js/**/*.js"
      ],
      app: [
        "app/js/app.js",
        "app/js/**/*.js"
      ]
    },
    css: {
      vendor: [
        "vendor/bower/cal-heatmap/cal-heatmap.css",
      ]
    },
    less: {
      compile: {
        options: {
          paths: [
            "vendor/bower/ng-table/ng-table.less",
            "vendor/bower/bootstrap/less/**/*.less",
            "app/css/**/*.less"
          ]
        }
      }
    }
  };
};
