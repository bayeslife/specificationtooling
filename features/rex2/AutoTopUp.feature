@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-66
Feature: Data Pool Auto Top Up
In order that customer is never without data
As a product manager
I want the data product to have an optional auto top up


Scenario Outline: Opt In
Given The customer has <ProductOffer.Name>
When the customer admin has visits their pool configuration page
Then the Auto Top Up Opt In is <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn-Editable>

Examples:
| ProductOffer.Name |ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn-Editable |
| Red Share for Business - Data | Not Editable |
| Red Share for Business 2 - Data | Editable |
| Personal Connectivity - Data | Editable |

@https://jira.vodafone.co.nz/jira/browse/RRE-68
Scenario Outline: Data Pool Auto Top Up Opt In/ Out
Given the customer has <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn> auto top up
Then the manual top up is <ProductSpecCharacteristic.ShareGroup-DataPool-ManualTopUp-OptIn>

Examples:
| ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn | ProductSpecCharacteristic.ShareGroup-DataPool-ManualTopUp-OptIn |
|  Enabled                                                      | Disabled |
|  Disabled                                                     | Enabled |


@https://jira.vodafone.co.nz/jira/browse/RRE-68
Scenario Outline: All Data Pack Consumed
Given The customer has <ProductOffer.Name>
And the customer has <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn> auto top up
And the customer has configured <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-Commitment>
When the customer has consumed all data associated with the monthly commitment
Then the configured <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-Commitment> is added to their account

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-OptIn | ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-Commitment |
| Red Share for Business 2 - Data |  Enabled | 500MB GB per user |
| Personal Connectivity - Data |  Enabled | 5GB per user |

Scenario Outline: Data Pool Auto Top Up Change Timeframe
Given The customer has changed their Data Pool Auto Top Up configuration
Then the change will be recorded and visible and active in the portal within one business day

Scenario Outline: Data Pool Change Options
Given The customer has visits their Data Pool configuration page
And the customer has  <ProductOffer.Name>
Then the available change options for the auto top up commitment are <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-Domain>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-Domain |
| Red Share for Business 2 - Data | From 500MB per user to 1GB per user |
| Red Share for Business - Data | From 5GB to N GB in terms increments of 1 GB |
| Personal Connectivity - Data | From 5GB to N GB in terms increments of 1 GB |


Scenario Outline: Auto Top Up Minimum Constraints
Given The customer has visited their Data Pool configuration page
And the customer has  <ProductOffer.Name>
And there are <ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers> service users
Then the available top up options for the auto top up are only those where the that satisify the Minimum Floor constraints <ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-CommitmentFloor>

Examples:
| ProductOffer.Name             | ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers | ProductSpecCharacteristic.ShareGroup-DataPool-AutoTopUp-CommitmentFloor |
| Personal Connectivity - Data  | 1000 | ???? |
