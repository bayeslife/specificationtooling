@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-58
Feature: Configurable Data Pool Commitment
In order to manage my monthly commitment to Vodafone
As a customer admin
I want to be able to reconfigure my Data Pool Commitment

Scenario Outline: Single Data Pool Per Billing Account
Given the customer billing account <BillingAccount.AccountId>
And The customer has <ProductOffer.Name>
Then the <ProductOffer.Name> is not available to ordered.
Examples:
| ProductOffer.Name | BillingAccount.AccountId |
| Red Share for Business - Data| 123 |
| Red Share for Business 2 - Data| 123 |
| Personal Connectivity - Data | 123 |

Scenario Outline: Data Pool Editable
Given The customer has <ProductOffer.Name>
And The customer is a <CustomerSegment> segment
Then the Data Pool is <ProductSpecCharacteristic.ShareGroup-DataPool-Configurable>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-Configurable |
| Red Share for Business - Data| Not Editable |
| Red Share for Business 2 - Data | Editable |
| Personal Connectivity - Data | Editable |

Scenario Outline: Data Pool Change Type
Given The customer has <ProductOffer.Name>
Then the Data Pool is expressed as <ProductSpecCharacteristic.ShareGroup-DataPool-EditType>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-EditType |
| Red Share for Business 2 - Data | Average Data Grant Per User |
| Personal Connectivity - Data | Total Data Grant |


Scenario Outline: Data Pool Change Timeframe
Given The customer admin has changed their Data Pool configuration
Then the change will be recorded and visible in the portal within one business day


Scenario Outline: Data Pool Change Options
Given The customer admin has visits their Data Pool configuration page
And the customer has <ProductOffer.Name>
Then the available change options for the Data Pool Size are <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-Commitment-Domain |
| Red Share for Business 2 - Data | From 500MB per user to 2GB per user |
| Red Share for Business - Data | From 5GB to N GB in terms increments of 5 GB |

@https://jira.vodafone.co.nz/jira/browse/RRE-86
@https://jira.vodafone.co.nz/jira/browse/RRE-60
Scenario Outline: Data Pool Minimum Constraints
Given The customer has visited their Data Pool configuration page
And the customer has  <ProductOffer.Name>
Then the available change options for the Data Pool Size are only those where the average data grant is above <ProductSpecCharacteristic.ShareGroup-DataPool-CommitmentFloor>

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-CommitmentFloor |
| Personal Connectivity - Data | 500MB |


@https://jira.vodafone.co.nz/jira/browse/RRE-67
Scenario Outline: Data Pool Configuration Change Effective Date
Given the customer has  <ProductOffer.Name>
And the customer has a bill cycle date of <BillingAccount.DayOfMonth>
When the customer has changed their service configuration on <Event.Date ChangeDate1>
And  the customer has changed their service configuration on <Event.Date ChangeDate2>
Then the current service configuration will be those changes made on <Event.Date ChangeDate3>

Examples:
| ProductOffer.Name | BillingAccount.DayOfMonth | Event.Date ChangeDate1 | Event.Date ChangeDate2 | Event.Date ChangeDate3 |
| Personal Connectivity - Data | 10 | 1 | 20 | 1 |
| Personal Connectivity - Data | 10 | 1 | 9 | 9 |


@https://jira.vodafone.co.nz/jira/browse/RRE-86
@https://jira.vodafone.co.nz/jira/browse/RRE-60
Scenario Outline: Automatic Resize
Given the customer has a DOM of <BillingAccount.DayOfMonth>
And the customer has  <ProductOffer.Name>
And the configured ProductSpecCharacteristic ShareGroup-DataPool-CommitmentFloor is below the minimum constraints defined at the product offer
And the subscribers in the share group has <ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers>
And the next available <ProductSpecCharacteristic.ShareGroup-DataPool-CommitmentFloor> value is within the product level
When the day of the month if <BillingAccount.DayOfMonth>
Then the customer pool size will become <ProductSpecCharacteristic.ShareGroup-DataPool-CommitmentFloor>

Examples:
| BillingAccount.DayOfMonth  | ProductOffer.Name | ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers | ProductSpecCharacteristic.ShareGroup-DataPool-CommitmentFloor |
| 1                          | Personal Connectivity - Data         | 100                         | 500MB |


Scenario Outline: Administrators have self service
Given A user visits the Data Pool configuration page
And the customer has <ProductOffer.Name>
And the customer has a product with a share group which is <ProductSpecCharacteristic.ShareGroup-DataPool-Configurable>
And the user is a member from the <ServiceSpecCharacteristic.ShareGroup-DataPool-Administrators> for the group
Then the user has options to set the commitments for the product.

Examples:
| ProductOffer.Name | ProductSpecCharacteristic.ShareGroup-DataPool-Configurable | ServiceSpecCharacteristic.ShareGroup-DataPool-Administrators |
| Personal Connectivity - Data | Editable | [ user@example.com ] |
