@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-109
Feature: Data Retention
As a customer
In order to investigate historical changes to my service
I want transaction logs to be retained

Scenario Outline: Data Retention
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
