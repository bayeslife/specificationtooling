@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-100
Feature: Transaction Visibility
As a customer, especially when I have multiple administrators,
I want to be able to see a filterable, searchable and
downloadable list of all changes made via self service,
so that I am in control of my services

Scenario Outline: Service Service Events To Be Logged
Given A user <ServiceUser.userId> is modifying Mobile Service Usage configuration on the self service page
And this user is viewing a <ServiceSpecCharacteristic.ShareGroup-GroupId>
When there is a <ServiceSpecCharacteristic.ShareGroup-ServiceProfile-LimitType> profile change
And this occurs at <Event.Time>
And this applies to <ServiceSpecCharacteristic.MSISDN>
Then an event of type <Event.Type> and value <Event.Value> is created and retrievable from the NoSql service
And this contains <ServiceUser.userId>
And this contains <Event.Time>
And this contains <ServiceSpecCharacteristic.ShareGroup-GroupId>

Examples:
| ServiceSpecCharacteristic.ShareGroup-GroupId | ServiceUser.userId | ServiceSpecCharacteristic.ShareGroup-ServiceProfile-LimitType  | Event.Type          | Event.Time | ServiceSpecCharacteristic.MSISDN |
| billingaccount1                              | user123     |  Soft                                                          | Soft Profile Change | now | 021 123 4567 |
| billingaccount1                              | user123     |  Hard                                                          | Hard Profile Change | now | 021 123 4567 |
| billingaccount1                              | user123     |  Hard                                                          | Hard Profile Change | now | 021 123 4567 |

Scenario Outline: Resize Service Events To Be Logged
Given the customer has a DOM of <BillingAccount.DayOfMonth>
And the configured ProductSpecCharacteristic ShareGroup-DataPool-CommitmentFloor is below the minimum constraints defined at the product offer
And the next available allowed options is <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment>
When the day of the month is <BillingAccount.DayOfMonth>
And the customer pool size becomes <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment>
Then an event of type <Event.Type> and value <Event.Value> is created and retrievable from the NoSql service
And this contains user identified a <ServiceUser.userId>
And this contains <Event.Time>
And this contains <ServiceSpecCharacteristic.ShareGroup-GroupId>
And this contains <ProductSpecCharacteristic.ShareGroup-DataPool-Commitment>

Examples:
| BillingAccount.DayOfMonth | ServiceSpecCharacteristic.ShareGroup-GroupId | ServiceUser.userId  | ProductSpecCharacteristic.ShareGroup-DataPool-Commitment | Event.Type       | Event.Value  | Event.Time |
| 1                         | billingaccount1                              | Vodafone     | 500MB                                                   | Data Pool Commitment Resize  | 500MB        |  now |

Scenario Outline: Viewable Transaction Logs
Given A user is viewing Mobile Service Usage transaction log on the self service page
And this user is viewing a <ServiceSpecCharacteristic.ShareGroup-GroupId>
And there has been a <Event.Type>  event raised
And this has occurred at <Event.Time>
When the transaction log is retreived
Then this event is viewable on this page
And this contains <ServiceUser.userId
And this contains <Event.Time>
And this contains <ServiceSpecCharacteristic.ShareGroup-GroupId>

Examples:
| ServiceSpecCharacteristic.ShareGroup-GroupId | ServiceUser.userId | Event.Type           | Event.Time |
| billingaccount1                              | user123     |  Soft Profile Change | now        |


Scenario Outline: View scope of transaction logs. The transaction log show events from the customer or for the Sharer Group.
Given A user <ServiceUser.userId> modifies Mobile Service Usage configuration on the self service page
And this user is viewing a <ServiceSpecCharacteristic.ShareGroup-GroupId>
When A different user <ServiceUser.userId user2> modifies Mobile Service Usage configuration on the self service page
And this user is viewing a different <ServiceSpecCharacteristic.ShareGroup-GroupId>
And both share groups are associated with the same customer
Then the first change is not visible to the second user

Scenario Outline: Impersonator visible in transaction log
Given A user <ServiceUser.userId> modifies Mobile Service Usage configuration on the self service page
And this user is impersonating another user <ServiceUser.userId user2>
When there is a <ServiceSpecCharacteristic.ShareGroup-ServiceProfile-LimitType> profile change
And the transaction log is retreived
Then this event is viewable on this page
And this event contains detail of the impersonator <ServiceUser.userId> and the impersontee <ServiceUser.userId user2>
