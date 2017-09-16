@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-87
Feature: Separation of Ready Government and Commercial Enterprise billing
In order enterprise and RG offers can be billed separately
As a product manager
I want separate pricing and contract terms for RG and Enterprise offers

Scenario Outline: Data Pack
Given The customer has <ProductOffer.Name>
Then the customers product will have month contract from <ProductSpecCharacteristic.ContractTerm>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ContractTerm |
| Red Share for Business - Data |  [0] |
| Red Share for Business 2 - Data |  [24,36] |


Scenario Outline: Connection
Given The customer has <ProductOffer.Name>
Then the customers product will have month contract from <ProductSpecCharacteristic.ContractTerm>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ContractTerm |
|  Red Share for Business - Data |  [0] |
|  Red Share for Business 2 - Data  |  [1,24,36] |
