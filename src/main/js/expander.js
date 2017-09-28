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

class Response {  
  constructor(){    
    this.result="";
  }
  append(astring){
    if(astring)
      this.result = this.result + astring;
  }
  toString(){
    return this.result;
  }
}

class Renderer{
  constructor(){
    this.buffer = null;
    this.gherkin = null;
    this.pickles = null;
  }

  renderScenario(scenario){   
    var b = this.buffer; 
    var s  = scenario;
    
    this.pickles.forEach(function(pickle,pickleIndex){      
      var p = pickle;
      var pi = pickleIndex;
      if(p.name == s.name){
        b.append("\n\t");
        b.append(scenario.name);
        b.append(":Example:");
        b.append(pi);

        scenario.steps.forEach(function(step,index){
          var step = scenario.steps[index];
          b.append('\n\t\t');
          b.append(step.keyword);
          
          var pickleStep = p.steps[index];
          //b.append(' ');
          b.append(pickleStep.text)
        })
      }
    });
  }
  
  renderFeature(feature){          
    var bf = this.buffer;
    var t = this;
    this.buffer.append('\nFeature: ')
    this.buffer.append(feature.name);
    if(feature.description){
      this.buffer.append('\n')
      this.buffer.append(feature.description);
    }  

    feature.children.forEach(function(scenario){
      bf.append("\n");
      t.renderScenario(scenario);      
    })
  
  }
  
  setGherkin(g){
    this.gherkin = g;
  }
  setPickles(p){
    this.pickles=p;
  }
  setBuffer(b){
    this.buffer=b;
  }
  render() {    
    this.renderFeature(this.gherkin.feature);
    return this.buffer.toString();
  }

}


function expand(metadata,featureSource){
  var buffer = new Response();
  var renderer = new Renderer();

  var gherkinDocument = parser.parse(featureSource);
  var pickles = new Gherkin.Compiler().compile(gherkinDocument);

  renderer.setGherkin(gherkinDocument);
  renderer.setPickles(pickles);
  renderer.setBuffer(buffer);
  renderer.render();

  console.log(buffer.toString());  
  return  buffer.toString();;
}



module.exports = {

  expand: expand,
}
