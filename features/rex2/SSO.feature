@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-111
Feature: Enterprise Portal Single Sign On
In order to administrators to access all their Ready Government services through ReadyHub
As a customer admin
I want to be single sign from ReadyHub to the Consumer Portal


Scenario Outline: Administrators provisioned with SSO role
Given A user identified with a specific readyhub user id <ServiceSpecCharacteristic.ShareGroup-DataPool-Administrator-UserId> is added to the set of Sharer Administrators for a group
When the order is provisioned
Then the user <ServiceSpecCharacteristic.ShareGroup-DataPool-Administrator-UserId> is assigned the <ServiceSpecCharacteristic.EnterprisePortal-SSORole> in ReadyHub

Examples:
| ServiceSpecCharacteristic.ShareGroup-DataPool-Administrator-UserId | ServiceSpecCharacteristic.EnterprisePortal-SSORole |
| jim@mbie.govt.nz | SSO_ConsumerPortal |


Scenario Outline: Administrators has SSO link
Given A user identified with a specific readyhub user id <ServiceSpecCharacteristic.ShareGroup-DataPool-Administrator-UserId> is added to the set of Sharer Administrators for a group
When the user logs into Ready Hub
Then a SSO link to the consumer portal is available

Examples:
| ServiceSpecCharacteristic.ShareGroup-DataPool-Administrator-UserId |
| jim@mbie.govt.nz |


Scenario Outline: Administrators SSO through to Consumer Portal
Given A user identified with a specific readyhub user id <ServiceSpecCharacteristic.ShareGroup-DataPool-Administrator-UserId> is added to the set of Sharer Administrators for a group
When the user select the SSO link
Then the browser is redirected to the consumer portal and displays the appropriate view without prompting the user to provide credentials.

Examples:
| ServiceSpecCharacteristic.ShareGroup-DataPool-Administrator-UserId |
| jim@mbie.govt.nz |
