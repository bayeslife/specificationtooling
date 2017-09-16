@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-65
Feature: Data Pool Manual Top Up
As a customer
In order to have full control of my company data usage
I want the data product to have an optional manual data up

Scenario Outline: All Data Pack Consumed
Given The customer has <ProductOffer.Name>
And the customer has <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn> auto top up
And the customer has configured <ProductSpecCharacteristic.ShareGroup-DataPool-ManualTopUp-Commitment>
When the customer has consumed all data associated with the monthly commitment
And the customer elects to manually top up
Then the configured <ProductSpecCharacteristic.ShareGroup-DataPool-ManualTopUp-Commitment> is added to their account

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn | ProductSpecCharacteristic.ShareGroup-DataPool-ManualTopUp-Commitment |
| Red Share for Business 2 - Data |  Disabled | 500MB GB per user |
| Personal Connectivity - Data |  Disabled | 5 GB |

Scenario Outline: Data Pool Manual Top Up Change Timeframe
Given The customer has changed their Data Pool Manual Top Up configuration
Then the change will be recorded and visible and active in the portal within immediately

Scenario Outline: Data Pool Change Options
Given The customer has visits their Data Pool configuration page
And the customer has  <ProductOffer.Name>
Then the available change options for the manual top up commitment are <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-Domain>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-Domain |
| Red Share for Business 2 - Data | From 500MB per user to 1GB per user |
| Red Share for Business - Data | From 1GB to N GB in terms increments of 1 GB |
| Personal Connectivity - Data | From 1GB to N GB in terms increments of 1 GB |
