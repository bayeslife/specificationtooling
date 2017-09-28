var assert = require('assert');


var systemUnderTest = require("../src/main/js/expander.js");  

var featureContent = " \
Feature: A sample feature \n\
This description \n\
\n\
Scenario Outline: Scenario1 \n\
    Given something <variable> \n\
    And this is the case \n\
    When this happens \n\
    Then this also happens \n\
    \n\
    Examples: \n\
     | variable | \n\
     | 1 | \n\
     \n\
Scenario Outline: Scenario2 \n\
    Given some condition \n\
    And this <variable> \n\
    When this happens \n\
    Then this also happens \n\
    \n\
    Examples: \n\
     | variable | \n\
     | 1 | \n\
     | 2 | "

describe('Given a simple feature file content', function() {
  before(function(){ })
  describe('When feature file is expanded', function() {  
    var expanded = systemUnderTest.expand({},featureContent)
    it('Then the expanded content should be the right number of lines ', function() {
      console.log(expanded);
      //console.log(expanded.split(/\n/))
      var l = expanded.split(/\n/).length
      assert.equal(20,l);
    });
    
  });
})
