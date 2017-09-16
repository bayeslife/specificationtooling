@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-101
Feature: Large Groups
As a product manager
In order to support customers with large numbers of sharers
I want self service functions to be responsive when there are large number of sharers in a data pool

Scenario Outline: Large group page load
Given A user views the Usage Management Self Service page
When the Data Pool has <ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers>
And there are <ServiceSpecCharacteristic.ShareGroup-SelfService-NumberOfConcurrentUsers> accessing the same page
Then the self service http request will respond load within <ServiceSpecCharacteristic.ShareGroup-SelfService-ResponseTime> seconds with 95% confidence

Examples:
| ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers | ServiceSpecCharacteristic.ShareGroup-SelfService-NumberOfConcurrentUsers | ServiceSpecCharacteristic.ShareGroup-SelfService-ResponseTime |
|  20000 | 5| 3 |

Scenario Outline: Sort large group
Given A user views the Usage Management Self Service page
When the Data Pool has <ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers>
Then there should be no noticeable lag to sort the sharers by sort criteria

Examples:
| ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers |
|  20000 |


Scenario Outline: Holistic large group update.
Given A user views the Usage Management Self Service page
When the Data Pool has <ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers>
And there is a profile update that applies to all users
Then the updates should happen asynchronously
And the updates should be processed serially

Examples:
| ServiceSpecCharacteristic.ShareGroup-DataPool-NumberOfSharers |
|  20000 |
