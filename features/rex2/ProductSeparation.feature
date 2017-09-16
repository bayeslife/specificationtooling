@REX2
@https://jira.vodafone.co.nz/jira/browse/RRE-107
Feature: Connections and data pack construct
In order that mobile data usage can be averaged across users
As a product manager
I want separate billing for a shared data pack and per user connection

@Inventory
Scenario Outline: Separate products on the bill
Given The customer has <ProductOffer.Name DataPool>
And the product existing under <BillingAccount.ID>
And a user has the <ProductOffer.Name Mobile>
And this product also in the same billing account <BillingAccount.ID>
When the bill is generated for the billing account <BillingAccount.ID>
Then the bill includes seperate line items for <ProductOffer.Name DataPool> product and <ProductOffer.Name Mobile> for the <msisdn>

Examples:
| ServiceSpecCharacteristic.MSISDN | ProductOffer.Name Data | ProductOffer.Name Mobile |
| 02112345676| Red Share for Business - Data |  Red Share for Business - Base - Data SIM Only |
| 02112345676| Personal Connectivity - Data |  Personal Connectivity - Base - Data SIM Only |
