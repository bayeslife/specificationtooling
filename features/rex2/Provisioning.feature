@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-106
Feature: Provisioning
As a product manager
In order to provide Usage Management Services to a customer
I want to be able to onboard the customer

Scenario Outline:
Given a customer has signed a subscription form for the <ProductOffer.Name>
When the provisioning team attempts to create an order in Siebel
Then they are able to find the product offer and configure it in Siebel

Examples:
| ProductOffer.Name |
|  Personal Connectivity - Data |
