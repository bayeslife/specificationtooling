var through = require('through2');
var debug = require('debug')('SpecificationExtractor');
var util = require('gulp-util');
//var json5 = require('json5');

var map = require('map-stream')

//const fs = require("pn/fs"); // https://www.npmjs.com/package/pn

var path = require('path');

var _ = require('underscore');

// var d3 = require('d3');

var Promise = require('bluebird');

// var generator = require("../../dist/html.js.js");
var readFiles = require('read-vinyl-file-stream');

var context=null;
var template = null;

var Gherkin = require('gherkin');
var parser = new Gherkin.Parser();

function validateProperty(fullyqualifiedproperty){
   let prop = fullyqualifiedproperty
  if(prop.indexOf('.')<0){
      prop = "General."+prop;
  }
  var property = prop.substring(0,prop.indexOf('.'))
  var instance = prop.substring(prop.indexOf('.')+1)
  if(instance.indexOf(" ")>=0)
    instance = instance.substring(0,instance.indexOf(" "));
  //console.log(instance)

  var validProperties = [ 'General','Customer','BillingAccount','Product', 'ProductOffer','CustomerFacingService','ProductSpecCharacteristic','ProductSpecCharacteristicValue','ServiceSpecCharacteristic'];
  if(validProperties.indexOf(property)<0){
    debug('Property not supported:'+property)
  }
  return {property:property,instancename:instance};
}


// var metadata = {
//   Product: {},
//   ProductSpecCharacteristic: {},
//   ServiceSpecCharacteristic: {},
// };

function extract(metadata,content){
  var gherkinDocument = parser.parse(content);

  var feature = gherkinDocument.feature;
  _.each(feature.children,function(scenario){
    _.each(scenario.examples,function(example){
      _.each(example.tableHeader.cells,function(cell,index){
          debug(cell.value);
          var {property,instancename} = validateProperty(cell.value);
          var instances = metadata[property];
          if(!instances)
              instances = metadata[property] = {};
          var instance = instances[instancename];
          if(!instance)
              instance = instances[instancename] = {domain: []};
          //console.log(instancename)
          _.each(example.tableBody,function(row){
              debug("\t"+row.cells[index].value)
              instance.domain.push(row.cells[index].value)
              instance.domain = _.uniq(instance.domain)
            });
        });
      });
  });
  //console.log(metadata);
  //metadata.Product = _.uniq(metadata.Product);
  //metadata.ProductSpecCharacteristic = _.uniq(metadata.ProductSpecCharacteristic);
  //metadata.ServiceSpecCharacteristic = _.uniq(metadata.ServiceSpecCharacteristic);
  return  metadata;
}


var toString = require("stream-to-string");

function render(){

  var transform = function(file, encoding, callback) {
      var str = null;

      console.log("y")
      if(file.isBuffer()){
        str = file.contents.toString()
         console.log(file.path);
          var meta = extract(str);
          //console.log(meta);
          file.contents = new Buffer(JSON.stringify(meta,null," "),'utf-8');
          callback(null,file);
      }
    };
  return through.obj(transform);
}

function report(metadata){
  var transform = function(file, encoding, callback) {
        file.contents = new Buffer(JSON.stringify(metadata,null," "),'utf-8');
        callback(null,file);
    };
  return through.obj(transform);
}


module.exports = {
  render: render,
  extract: extract,
  report: report
}
