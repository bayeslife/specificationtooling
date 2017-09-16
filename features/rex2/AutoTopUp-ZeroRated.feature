@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-112
Feature: Zero Rated Data Pool Auto Top Up
As a large enterprise customer I require flexibility and cost certainty in my business, I need to keep to budgets.
I do not like the data overage charge model for mass market customers, as it does not suit my business.
I do not want to be surprised (or stung with overage charges) when my group goes over that data limit.


Scenario Outline: Opt In
Given The customer has <ProductOffer.Name>
When a customer agent reviews the <ProductOffer.Name> configuration in the CRM
And when the share group is <ProductSpecCharacteristic.ShareGroup-DataPool-Configurable>
And when the number of Sharers in the Share Group exceeds <ProductSpecCharacteristic.ShareGroup-AutoTopUp-ZeroRate-MinimumUserFloor>
Then an opt in checkbox is presented to the customer agent as  <ProductSpecCharacteristic.ShareGroup-AutoTopUp-ZeroRate-Enabled>

Examples:
| ProductOffer.Name |ProductSpecCharacteristic.ShareGroup-DataPool-Configurable|ProductSpecCharacteristic.ShareGroup-AutoTopUp-ZeroRate-MinimumUserFloor |ProductSpecCharacteristic.ShareGroup-AutoTopUp-ZeroRate-Enabled |
| Red Share for Business - Data | Not Editable | 0 | Not Enabled |
| Personal Connectivity - Data | Editable | 8500 | Enabled |

Scenario Outline: Billing
Given The customer has <ProductOffer.Name>
And the zero rate auto top up opt in checkbox is <ProductSpecCharacteristic.ShareGroup-AutoTopUp-ZeroRate-Enabled>
When the first auto top of the bill cycle is rated
Then the charge for this top up is <ProductOfferPrice.ShareGroup-AutoTopUp-ZeroRate-Charge>.

Examples:
| ProductOffer.Name |ProductSpecCharacteristic.ShareGroup-DataPool-Configurable|ProductSpecCharacteristic.ShareGroup-AutoTopUp-ZeroRate |
| Personal Connectivity - Data | Enabled | 0 |
