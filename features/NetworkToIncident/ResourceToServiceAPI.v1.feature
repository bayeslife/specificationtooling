@NetworkToIncident
Feature: Resource To Service API Contract

As an architect
I want an API available to Impact Server to retrieve high level service information when provided with low level resource or resource facing service information.
so that Impact Server can deduplicate Network Events into higher level Service Events.

@Input:Device-Host
@Paging: No
Scenario Outline: A resource is not associated with any RFS or CFS
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has NO device corresponding to that identifier
When the Impact Server invokes the Resource To Service API and provides the device identified as [<ServiceSpecCharacteristic.Router-HostName>]
Then the response is an empty result

Examples:
| ServiceSpecCharacteristic.Router-HostName |
| Host123                                   |

@Input:Device-Host
@Paging: No
Scenario Outline: A resource is directly associated with a service
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has a device corresponding to that identifier and this is linked to a single resource facing service [<ResourceFacingeService.Id>]
When the Impact Server invokes the Resource To Service API
Then the response is contains details of the RFS including service id [<ResourceFacingeService.Id>]
And the response contains service type [<Service.Type>]
And the response contain the service specification [<ServiceSpecification.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName | ResourceFacingeService.Id | Service.Type | ServiceSpecification.Id |
| Host123                                   | PIP123                    | RFS          | PIP                     |

@Input:Device-Host
@Paging: No
Scenario Outline: A resource is indirectly associated with a service
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has a device corresponding to that identifier and this is linked to a single resource facing service [<ResourceFacingeService.Id>]
And the resource facing service is a dependency of a customer facing service [<CustomerFacingService.Id>]
When the Impact Server invokes the Resource To Service API
Then the response is contains details of the RFS including service id [<CustomerFacingService.Id>]
And the response contains service type [<Service.Type>]
And the response contain the service specification [<ServiceSpecification.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName | ResourceFacingeService.Id | Service.Type | ServiceSpecification.Id | CustomerFacingService.Id |
| Host123                                   | PIP123                    | CFS          | WAN                     | WAN1                     |

@Input:Device-Host
@Paging: No
Scenario Outline: A resource is indirectly associated with multiple services
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has a device corresponding to that identifier and this is linked to a single resource facing service [<ResourceFacingeService.Id>]
And the resource facing service is a dependency of a list of customer facing services identified as [<CustomerFacingService.Id>]
When the Impact Server invokes the Resource To Service API
Then the response is contains details of the CFS identified by the list of service id [<CustomerFacingService.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName | ResourceFacingeService.Id | CustomerFacingService.Id |
| Host123                                   | PIP123                   | Telephone1,Presence1     |


@Input:Device-Host
@Paging: No
Scenario Outline: A resource is directly associated with multiple services and those service are associated with multiple services
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has a device corresponding to that identifier and this is linked to a multiple resource facing services identified as [<ResourceFacingeService.Id>]
And the resource facing services are furthermore associated with services identified as [<CustomerFacingService.Id>]
When the Impact Server invokes the Resource To Service API
Then the response is contains details of the CFS identified by the list of service id [<CustomerFacingService.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName | ResourceFacingeService.Id | CustomerFacingService.Id                      |
| Host123                                   | PIP123,PIP456             | Telephone1,Presence1,Telephone2,Presence2     |
