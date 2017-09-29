Feature: Use of service verfication meta data

Scenario Outline: Look up the verification test
Given A verification test has been registered
And the verification test is register with tag
When Metadata is returned
Then Something

Examples:
| tag.expression |
| tag1 |
