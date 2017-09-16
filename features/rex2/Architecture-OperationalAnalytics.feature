@REX2
Feature: Operational Analytics
As an operations person
In order to investigate correlations between activity in application components
I want transaction logs to index by an operational analytics platform.

Scenario Outline: Searchable Application activity
Given An administrator has modified Mobile Service Usage configuration on the self service page
And this change this change has been assigned <TransactionId>
When an administrator is views the operational analytics tool after the event
Then then the event for that <TransactionId> should be visible in the operational analystics platform

Examples:
| TransactionId |
| 123  |


Scenario Outline: Correlation activity.
Given An administrator <ServiceUser.userId> has modified Mobile Service Usage configuration on the self service page
And this change has been for the group identified by <ServiceSpecCharacteristic.ShareGroup-GroupId>
And this has occurred at <Event.Time Past>
When an administrator is viewing the transaction log for group identified by <ServiceSpecCharacteristic.ShareGroup-GroupId>
And this is occurring at <Event.Time Present>
Then the transaction event is <Visible> in the self service page.
And this contains <ServiceUser.userId>
And this contains <Event.Time Past>
And this contains <ServiceSpecCharacteristic.ShareGroup-GroupId>

Examples:
| ServiceSpecCharacteristic.ShareGroup-GroupId | ServiceUser.userId | Event.Time Past | Event.Time Present | Visible      |
| billingaccount1                              | user123            |  11 months ago  | now                |  Visible     |
| billingaccount1                              | user123            |  12 months ago  | now                |  Not Visible |
