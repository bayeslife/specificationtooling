var through = require('through2');
var debug = require('debug')('SpecificationExtractor');
var util = require('gulp-util');


var { EventEmitter} = require('events');

var map = require('map-stream')

var path = require('path');

var _ = require('underscore');

// var mysupport = require("./steps.js");
// var world = require("./world.js")

var Promise = require('bluebird');

var readFiles = require('read-vinyl-file-stream');

var context=null;
var template = null;

var Cucumber = require('cucumber');
var ansi_up = require('ansi_up');


var Gherkin = require('gherkin');
var parser = new Gherkin.Parser();


function tester(metadata,featureSource){

  const eventBroadcaster = new EventEmitter()
  const eventDataCollector = new Cucumber.formatterHelpers.EventDataCollector(
    eventBroadcaster
  )

  eventBroadcaster.on("pickle",function(event){
    //console.log(JSON.stringify(event,null," "));
  })
   const testCases = Cucumber.getTestCases({
    eventBroadcaster,
    pickleFilter: new Cucumber.PickleFilter({}),
    source: featureSource,
    uri: '/feature'

  })
 
  Cucumber.supportCodeLibraryBuilder.reset('')
  Cucumber.defineSupportCode(mysupport);
  var supportCodeLibrary = Cucumber.supportCodeLibraryBuilder.finalize()

  // let formatterOptions = {
  //   colorsEnabled: true,
  //   cwd: '/',
  //   eventBroadcaster,
  //   eventDataCollector,
  //   log(data) {
  //     console.log(data);
  //   },
  //   supportCodeLibrary
  // }
  // Cucumber.FormatterBuilder.build('progress', formatterOptions)

      var runtime = new Cucumber.Runtime({
        eventBroadcaster,
        testCases,
        supportCodeLibrary,      
      })
    //  var listener = Cucumber.Listener.Formatter(formatterOptions);
    //  cucumber.attachListener(listener);
    try {
      runtime.start(function() {
        console.log("here")
      });
    }catch(err){
      console.log(err);
    }
  

 


  return  metadata;
}

var CustomWorld = function() {
};

CustomWorld.prototype.environment = "DEV";

CustomWorld.prototype.setEnv = function(e) {
  CustomWorld.prototype.environment =e;
};

function mysupport(context){
  
    //context.setWorldConstructor(CustomWorld);
    var Given = context.Given
    var When = context.When
    var Then = context.Then

    //context.setWorldConstructor(CustomWorld);

  
    // context.registerHandler("BeforeScenario",function(scenario, callback){
    //   //console.log("scenario");
    //   //console.log(scenario)
    //   callback();
    // })
  
    // context.registerHandler("BeforeStep",function(step, callback){
    //   //console.log("step");
    //   //console.log(step);
    //   callback();
    // })

  //   context.defineParameterType({
  //   regexp: /\w+/,
  //   transformer: function(d){
  //     return d;
  //   },
  //   typeName: 'thing'
  // })
    // 

    Given(/^abc (\d+)$/, function(item) {    
      console.log("Given:")
    });

  
    Then('abc2', function() {
      console.log("Then")
    });
  
    // When('abc3', function() {
    //   console.log("When")
    // });
  
  
  }


module.exports = {
  tester: tester,
}
