@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-102
Feature: Product Configuration
As a product manager
In order to support both Ready Government and Ready Business Usage Sharing products
I want Rex2 service capability to be responsive to a product specifications.

Scenario Outline: Product Spec API drives UI
Given A user views the Mobile Usage Management Self Service page for a particular group
And the group realizes the product offer <ProductOffer.Name>
When product specification in Siebel has a configurable characteristic ShareGroup-Plan
And the complete set of values in Siebel are <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain>
Then Siebel offers an API to retrieve the complete set of values
And the self service page should display the full set of options including <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain>

Examples:
| ProductOffer.Name               | ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain |
|  Red Share for Business 2 - Data   | [1GB,2GB] |


Scenario Outline: Available Service configuration API drives UI
Given A user views the Usage Management Self Service page for a particular group
And the group realizes the product offer <ProductOffer.Name>
When product specification in Siebel has a configurable characteristic ShareGroup-Plan
And the Available values (a subset of the complete set of values) in Siebel are <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain>
Then Siebel offers an API to retrieve the Available set of values
Then self service page should display the available of options including <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain>

Examples:
| ProductOffer.Name               | ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain |
|  Red Share for Business 2 - Data   | [1GB,2GB] |
