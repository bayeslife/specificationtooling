@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-110
Feature: Impersonation
As a customer operations team member
I want to be able to be able to log into the self service portal
and see and operate in the portal as the customers sees it
so that I can assist customers on their behalf

Scenario Outline: Logging of user and impersonating user
Given A operations staff member <ServiceUser.userId OPS> is logged into the self service portal
And they are impersonating a customer user <ServiceUser.userId Customer>
When there is a profile change
Then an event is created and retrievable from the NoSql service
And this contains both the <ServiceUser.userId Customer> as well as the <ServiceUser.userId OPS>

Examples:
| ServiceUser.userId OPS | ServiceUser.userId Customer |
| opsuser123     | customeruser123     |
