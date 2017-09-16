var pkg = require('./package.json');

var debug = require('debug')('extractor');

var path = require('path');
var gulp = require('gulp');

var clean = require('gulp-rimraf');
// var webserver = require('gulp-webserver');
//var tap = require('gulp-tap');
//var merge = require('merge-stream');
//var insert = require("gulp-insert");
// var rename = require("gulp-rename");
var concat = require('gulp-concat');
//var browserify = require('browserify');
// var source = require('vinyl-source-stream');
// var buffer = require('vinyl-buffer');
// var strip = require('gulp-strip-comments');

var readFiles = require('read-vinyl-file-stream');

var extractor = require("./src/main/js/extractor.js");

var fs = require("fs");

var Promise = require('bluebird');


function getArrayOfFeatureFolders(dir) {
  return fs.readdirSync(dir)
    .filter(function(file) {
      return fs.statSync(path.join(dir, file)).isDirectory();
    });
}

gulp.task('extract', [], function() {  
  var featureFolders = getArrayOfFeatureFolders("Features");
  var tasks = featureFolders.map(function(featureFolder) {    
    var metadata = {};
    return gulp.src("features/"+featureFolder+"/*.feature")
      .pipe(readFiles(function(content,file,stream,cb){
        debug(file.path);
        extractor.extract(metadata,content)
        
        cb(null,"");
      }))
      .pipe(concat(featureFolder+".json"))
      .pipe(extractor.report(metadata))
      .pipe(gulp.dest('build/normalized/'))      
  })
});


gulp.task('clean', [], function() {
  console.log("Clean all files in build folder");
  return gulp.src("build/*", { read: false }).pipe(clean());
});

