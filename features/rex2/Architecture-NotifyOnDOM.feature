@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-103
Feature: Notify On Bill Cycle Date
As a customer user
In order to be aware that data is available for use
I want to receive a notification at the start of the bill cycle.

Scenario Outline: Matrix event generated
Given A sharer is a member of a group
And the group realizes the product offer <ProductOffer.Name>
And the group is associated with a billing account with a DOM of <BillingAccount.BillingDateOfMonth>
When the date <BillingAccount.BillingDateOfMonth> arrives
Then <Application.Component> should generate an event
And this should include the event type <Event.Type> and <ServiceSpecCharacteristic.ShareGroup-GroupId> and <ProductOffer.Name>

Examples:
| Application.Component | ProductOffer.Name                 | BillingAccount.BillingDateOfMonth | Event.Type | ServiceSpecCharacteristic.ShareGroup-GroupId | ProductOffer.Name |
| Matrix                |  Red Share for Business 2 - Data  | 1                                 | StartBillCycle    | Group1 | Personal Connectivity - Data |


Scenario Outline: LogStash Process Event
Given Matrix has generated a event of type <Event.Type> with <Event.Id>
Then a <Application.Component> should processed the event
And invoke an API <API.NotifyEvent> to notify the event id <Event.Id> and type <Event.Type> and <ServiceSpecCharacteristic.ShareGroup-GroupId> and <ProductOffer.Name>

Examples:
| Application.Component | Event.Type       | Event.Id |  ServiceSpecCharacteristic.ShareGroup-GroupId | ProductOffer.Name |
| Logstash              | StartBillCycle   | Event1   | Group1                                        | Personal Connectivity - Data |

Scenario Outline: Rest Server process notification
Given a share group identified by <ServiceSpecCharacteristic.ShareGroup-GroupId> with  exists
And the group has a subscriber <ServiceSpecificationCharacteristic.UserId>
And the subscriber has  <ServiceUser.ContactEmailForNotification>
When An API is invoked  to notify the event type <Event.Type> and <ServiceSpecCharacteristic.ShareGroup-GroupId> and <ProductOffer.Name>
Then the <Application.Component> will invoke the API <API.Communication> to deliver a notification
And include the <ServiceUser.ContactEmailForNotification>

Examples:
| Application.Component | Event.Id  | Event.Type         | ServiceSpecCharacteristic.ShareGroup-GroupId | ProductOffer.Name | API.Communication | ServiceUser.ContactEmailForNotification |
| RestServer            | Event1    | StartBillCycle     | Group1                                       | Personal Connectivity - Data | /integration/sim/service/Communication /1.0 |  john@VF.com |
