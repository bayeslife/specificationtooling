@NetworkToIncident
Feature: Resource To Service API Contract

As a customer
I want to have visibility of Network Outage Events that may have effected my Services
so that I am confident that Vodafone will be aware of service outages without having to raise Incidents myself.

As a resolver
I want to have Incidents raised to myself that are raised to the correct resolver team and are only raised once for each root cause
so that I dont have to waste time modifying multiple Incidents for a single root cause.

@Input:Device-Host
@Paging: No
Scenario Outline: A resource is not associated with any RFS or CFS
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has NO device corresponding to that identifier
When the Impact Server invokes the Resource To Service API
Then the response is an empty result

Examples:
| ServiceSpecCharacteristic.Router-HostName |
| Host123                                   |

@Input:Device-Host
@Paging: No
Scenario Outline: A resource is directly associated with a service
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has a device corresponding to that identifier and this is linked to a single resource facing service [<Service.Id>]
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
Then the response is contains details of the RFS including service id [<Service.Id>]
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
Then the response is contains details of the CFS identified by the list of service id [<Service.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName | ResourceFacingService.Id | CustomerFacingService.Id |
| Host123                                   | PIP123                   | Telephone1,Presence1     |


@Input:Device-HostAndPort
@Paging: No
Scenario Outline: A resource is identified by Host and Port
Given
And
When
Then


@Input:Device-Interface
@Paging: No
Scenario Outline: A resource is identified by Interface
Given
And
When
Then

@Input:Device-and-RFS
@Paging: No
Scenario Outline: An RFS is provided as input
Given
And
When
Then


@Input:Device-Host
@Paging: Yes
Scenario Outline: A resource is indirectly associated with a large set of services
Given A device identified as [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Don River has a device corresponding to that identifier and this is indirectly linked to list of [<CustomerFacingService.Count N>] services
When the Impact Server invokes the Resource To Service API
And indicated no more than [<CustomerFacingService.Count M>] services to be returnd
Then the response is contains details of the CFS identified by the list of service id [<CustomerFacingService.Count O>]

Examples:
| ServiceSpecCharacteristic.Router-HostName |
| Host123                                   | PIP123                   | Telephone1,Presence1     |
