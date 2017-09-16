@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-104
Feature: Capacity
As a product manager
In order to provide Usage Management Services to all customers
I want the solution to perform well at a large scale of customers

Scenario Outline: Total Capacity
Given the solution has <Statistics.CustomerNumbers> customers with <Statistics.AverageSharersPerGroup> sharers per customer share group
When a representative data set is loaded against any application component
Then the performance of any interface remains within specification

Examples:
| Statistics.CustomerNumbers  | Statistics.AverageSharersPerGroup |
|  1000                       | 1000 |
