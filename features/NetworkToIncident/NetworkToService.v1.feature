@NetworkToIncident
Feature: Reify Service Event

As a customer
I want to have visibility of Network Outage Events that may have effected my Services
so that I am confident that Vodafone will be aware of service outages without having to raise Incidents myself.

As a resolver
I want to have Incidents raised to myself that are raised to the correct resolver team and are only raised once for each root cause
so that I dont have to waste time modifying multiple Incidents for a single root cause.

@FailureComponent:Primary
@PreviousServiceEvent:False
@ServiceInformation:NotAvailable
@ServiceEvent:NotCreated
@ImpactedCustomers:None
Scenario Outline: A failing primary device with no associated avaialable service information will create an new Service Event
Given Router [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And there is no previous Service Event identifed for this resource
And the network event status is [<NetworkEvent.status>]
And there is no service information in the Network Event
And Resource To Service API when invoked with [<ServiceSpecCharacteristic.Router-HostName>] has no corresponding Services
When impact server receives this Network Event
Then there is no Service Event api invocation

Examples:
| ServiceSpecCharacteristic.Router-HostName | NetworkEvent.status |
| Host123                                    | Down               |

@FailureComponent:Primary
@ServiceInformation:NotAvailable
@PreviousServiceEvent:False
@ServiceEvent:Created
@ImpactedCustomers:Single
@ImpactedSegment:ReadyGovernment
Scenario Outline: A newly failing primary components with externally enriched service identified
Given A failing router [<ServiceSpecCharacteristic.Router-HostName>] has resulted in generation of a network event with status [<NetworkEvent.status>]
And the Network Event has been previously enriched and has a Service identified as [<CustomerFacingService.Id>]
And Impact Server has no previous incomplete Service Event for the Network resource
And the Resource To Service API has an no association from the router to a CFS
When impact server receives this Network Event
Then the Service Event api is invoked
And A service event id is generated
And the primary service is identified by name [<CustomerFacingService.Id>]
And the CFS Service status is identified as [<ServiceEvent.status>]
And the Service Event is associated with [<CustomerFacingService.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName |  NetworkEvent.status | CustomerFacingService.Id | ServiceEvent.status |
| Host123                                   |  Down                | PIP1                     | Service Down        |


@FailureComponent:Primary
@ServiceInformation:Available
@PreviousServiceEvent:False
@ServiceEvent:Created
@ImpactedCustomers:Single
Scenario Outline: A newly failing primary components associated with a specific service
Given A failing router [<ServiceSpecCharacteristic.Router-HostName>] has resulted in generation of a network event with status [<NetworkEvent.status>]
And Impact Server has no previous incomplete Service Event for the Network resource
And the Resource To Service API has an association from the router to the CFS [<CustomerFacingService.Id>]
When impact server receives this Network Event
Then the Service Event api is invoked
And A service event id is generated
And the primary service is identified by name [<CustomerFacingService.Id>]
And the CFS Service status is identified as [<ServiceEvent.status>]
And the Service Event is associated with [<CustomerFacingService.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName |  NetworkEvent.status | CustomerFacingService.Id | ServiceEvent.status |
| Host123                                   |  Down                | LAN1                    | Service Down        |
| Host456                                   |  Down                | WIFI1                   | Service Down        |


@FailureComponent:Primary
@ServiceInformation:NotAvailable
@PreviousServiceEvent:True
@Flapping
@ServiceEvent:Updated
@ImpactedCustomers:Single
Scenario Outline: A flapping primary or secondary device failure event raises no further Service Event
Given A router [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And the network event status is [<NetworkEvent.status>]
And a previous event was identified as [<ServiceEvent.id>]
And the Service associated with the ServiceEvent is identified as [<CustomerFacingService.Id>]
When impact server receives this Network Event
Then the Resource To Service API is invoked
And the Service Event api is not invoked

Examples:
| ServiceSpecCharacteristic.Router-HostName | ServiceEvent.id  | NetworkEvent.status  | CustomerFacingService.Id |
| Host123                                    | ServiceEvent1234 | Down                | LAN1                     |

@FailureComponent:Primary
@FailureComponent:Secondary
@PreviousServiceEvent:True
@ServiceInformation:NotAvailable
@ServiceInformation:Available
@ImpactedCustomers:Single
Scenario Outline: A network primary device up event results in an invocation of the Service Event API after the tolerance period
Given A router [<ServiceSpecCharacteristic.Router-HostName>] has generated a resource up status identified as [<NetworkEvent.status>]
And a new or updated Network Event is available in Netcool
And Resource To Service API has an association to a CFS identified as [<CustomerFacingService.Id>]
And Impact Server previously generated a Service Event identified as <ServiceEvent.id>
And there have been no subsequent Network events for a period of the Configured Service Event Frequency Tolerance
When the Configured Service Event Frequency Tolerance period is exceeded
Then the Service Event api is invoked
And the Service Event id is <ServiceEvent.id>
And the Service Up status is identified as <ServiceEvent.status>
And the ServiceEvent is completed

Examples:
| ServiceSpecCharacteristic.Router-HostName | CustomerFacingService.Id |  NetworkEvent.status | ServiceEvent.id| ServiceEvent.status |
| Host123                                   | LAN1                     |  Up                  | ServiceEvent123| Service Up          |



@FailureComponent:Primary
@PreviousServiceEvent:False
@ServiceInformation:Available
@ImpactedCustomers:Multiple
@ServiceEvent:Created
Scenario Outline: A failing device associated with more than one than one CFS
Given A router [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Resource To Service API has an association from the router to a list of CFS identified as <CustomerFacingService.Id>
When Impact Server receives this Network Event
And identifies the need for new Service Events
Then the Service Event api is invoked once
And the Service Events primary service is identified list of [<CustomerFacingService.Id>]
And the Service Event is updated to reflect the associate to the list of CFS identified as [<CustomerFacingService.Id>]

Examples:
| ServiceSpecCharacteristic.Router-HostName | CustomerFacingService.Id |
| Host123                                   | LAN1,LAN2                |

@FailureComponent:Secondary
@ServiceInformation:Available
@PreviousServiceEvent:True
@ServiceEvent:Updated
@ImpactedCustomers:Single
Scenario Outline: A failing secondary component with available associated service information
Given A switch providing the LAN has raised a Network Event
And that is available in Netcool and associated with service event [<ServiceEvent.id>]
And a router has previously failed and raised a Network Event that is available in Netcool
And the ServiceEvent has been associated with CFS list identified as [<CustomerFacingService.Id>]
And the network event status is [<NetworkEvent.status>]
And Resource To Service API has corresponding Services associated with the switch of [<CustomerFacingService.Id overlapping>]
When impact server receives this Network Event
And retrieves service information from the Resource To Service API
And because one of the services overlaps
Then no service event api is invoked
And the ServiceEvent is updated to reflect the union of [<CustomerFacingService.Id>] and [<CustomerFacingService.Id overlapping>]

Examples:
| ServiceEvent.Id | ServiceSpecCharacteristic.Switch-HostName | CustomerFacingService.Id | CustomerFacingService.Id overlapping | NetworkEvent.status |
| ServiceEvent123 | Switch123                                 | LAN1,LAN2                | LAN2,LAN3                            | Down                |


@FailureComponent:Primary
@PreviousServiceEvent:False
@ServiceEvent:Created
Scenario Outline: When an Incident is created, the Incident Id is reflect into the synthetic Service Event
Given A Service Event has been raised via the Service Event API
When impact server receives an Incident identifier from AO
Then the Service Event is updated with the Incident identifier


@Exception
@PreviousServiceEvent:False
@ServiceEvent:Created
@ServiceEvent:Updated
@ImpactedCustomers:Single
Scenario Outline: The Resource To Service API is offline but an Service Event is still created.
Given A router has failed and raised a Network Event that is available in Netcool
And this is the first network event corresponding to this resource
And Resource To Service API is offline
When impact server receives this Network Event
Then a service event api is invoked but no service information is included.
