@NetworkToIncident
Feature: Resource To Service API Test Scenarios

As an architect
I want an to ensure that APIs are testable
so that functional behaviour of APIs can be functionally and regression tested in a repeatable and automated manner.

Scenario Outline: Functionally test API for simple PIP service
Given the NetworkAnalyzer Test environment
When a circuit defined in terms of Provider Edge Router [ProviderEdge1] and IAD [OneAccess1] with an over the top PIP Service [PIP123]
And a functional API test is to be run either as part of a functional or regression test
And an API request is made for the device [ProviderEdge1]
Then the circuit data is known to be represented in NetworkAnalyzer prior to sending the request
And the API response includes PIP service [PIP123]
