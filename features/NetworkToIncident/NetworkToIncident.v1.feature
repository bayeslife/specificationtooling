@NetworkToIncident
Feature: Reify Incident

As a customer
I want to have visibility of Network Outage Events that may have effected my Services
so that I am confident that Vodafone will be aware of service outages without having to raise Incidents myself.

As a resolver
I want to have Incidents raised to myself that are raised to the correct resolver team and are only raised once for each root cause
so that I dont have to waste time modifying multiple Incidents for a single root cause.

@Component: Impact
@FailureComponent:Primary
@PreviousServiceEvent:False
@ServiceInformation:NotAvailable
@ServiceEvent:NotCreated
@ImpactedCustomers:None
Scenario Outline: A failing primary device with no associated available service information will not create an new Service Event
Given Router [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And there is no previous Service Event identifed for this resource
And the network event status is [<NetworkEvent.status>]
And there is no service information in the Network Event
And Resource To Service API when invoked with [<ServiceSpecCharacteristic.Router-HostName>] has no corresponding Services
When Impact Server receives this Network Event
Then Impact Server invokes the Resource To Service API
And there is no Service Event created in Netcool-Omnibus
And there is no Service Event api invocation

Examples:
| ServiceSpecCharacteristic.Router-HostName | NetworkEvent.status |
| Host123                                    | Down               |

@Component: Impact
@FailureComponent:Primary
@ServiceInformation:NotAvailable
@PreviousServiceEvent:False
@ServiceEvent:Created
@ImpactedCustomers:Single
@ImpactedSegment:ReadyGovernment
Scenario Outline: A newly failing primary component with externally enriched service identified
Given A failing router [<ServiceSpecCharacteristic.Router-HostName>] has resulted in generation of a network event with status [<NetworkEvent.status>]
And the Network Event has been previously enriched and has a Service identified as [<CustomerFacingService.Id>]
And Impact Server has no previous incomplete Service Event associated with the Network resource
And the Resource To Service API has an no association from the router to a CFS
When Impact Server receives this Network Event
Then A service event id is generated
And the primary service is identified by name [<CustomerFacingService.Id>]
And the CFS Service status is identified as [<ServiceEvent.status>]
And the Service Event is associated with [<CustomerFacingService.Id>]
And the Service Event is associated with Resource [<ServiceSpecCharacteristic.Router-HostName>]
Then a Service Event notification is published

Examples:
| ServiceSpecCharacteristic.Router-HostName |  NetworkEvent.status | CustomerFacingService.Id | ServiceEvent.status |
| Host123                                   |  Down                | PIP1                     | Service Down        |

@Component: Impact
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
Then A service event id is generated
And the primary service is identified by name [<CustomerFacingService.Id>]
And the CFS Service status is identified as [<ServiceEvent.status>]
And the Service Event is associated with [<CustomerFacingService.Id>]
And the Service Event is associated with Resource [<ServiceSpecCharacteristic.Router-HostName>]
And the Service Event notification is published

Examples:
| ServiceSpecCharacteristic.Router-HostName |  NetworkEvent.status | CustomerFacingService.Id | ServiceEvent.status |
| Host123                                   |  Down                | LAN1                    | Service Down        |
| Host456                                   |  Down                | WIFI1                   | Service Down        |

@Component: Impact
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
When Impact Server receives this Network Event
Then the Resource To Service API is invoked
And there is no Service Event notification published

Examples:
| ServiceSpecCharacteristic.Router-HostName | ServiceEvent.id  | NetworkEvent.status  | CustomerFacingService.Id |
| Host123                                    | ServiceEvent1234 | Down                | LAN1                     |

@Component: Impact
@FailureComponent:Primary
@FailureComponent:Secondary
@PreviousServiceEvent:True
@ServiceInformation:NotAvailable
@ServiceInformation:Available
@ImpactedCustomers:Single
Scenario Outline: A network primary device up event results in an invocation of the Service Event API after the tolerance period
Given A router [<ServiceSpecCharacteristic.Router-HostName>] has generated a resource up status identified as [<NetworkEvent.status>]
And a new or updated Network Event is available in Netcool for the Resource [<ServiceSpecCharacteristic.Router-HostName>]
And Resource To Service API has an association to a CFS identified as [<CustomerFacingService.Id>]
And Impact Server previously generated a Service Event identified as <ServiceEvent.id>
And there have been no subsequent Network events for a period of the Configured Service Event Frequency Tolerance
When the Configured Service Event Frequency Tolerance period is exceeded
Then the Service Event id is <ServiceEvent.id>
And the Service Up status is identified as <ServiceEvent.status>
And the ServiceEvent is completed
And the Service Event update notification is published

Examples:
| ServiceSpecCharacteristic.Router-HostName | CustomerFacingService.Id |  NetworkEvent.status | ServiceEvent.id| ServiceEvent.status |
| Host123                                   | LAN1                     |  Up                  | ServiceEvent123| Service Up          |

@Component: Impact
@FailureComponent:Primary
@PreviousServiceEvent:False
@ServiceInformation:Available
@ImpactedCustomers:Multiple
@ServiceEvent:Created
Scenario Outline: A failing device associated with more than one than one CFS
Given A router [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And Resource To Service API has an association from the router to a list of CFS identified as <CustomerFacingService.Id>
And Impact Server has no previous incomplete Service Events for any of the corresponding services
When Impact Server receives this Network Event
Then then the Resource to Service API is invoked to retrieve the services
And a single Service Event is created into Netcool-Omnibus for and associated with all the CFS [<CustomerFacingService.Id>]
And the Service Event is associated with Resource [<ServiceSpecCharacteristic.Router-HostName>]
And a Service Event created notification is published.

Examples:
| ServiceSpecCharacteristic.Router-HostName | CustomerFacingService.Id |
| Host123                                   | LAN1,LAN2                |

@Component: Impact
@FailureComponent:Secondary
@ServiceInformation:Available
@PreviousServiceEvent:True
@ServiceEvent:Updated
@ImpactedCustomers:Single
Scenario Outline: A failing secondary component with available associated service information
Given A switch providing the LAN has raised a Network Event
And that is available in Netcool and associated with service event [<ServiceEvent.id>]
And a router has previously failed and raised a Network Event that is available in Netcool
And the ServiceEvents have been associated with CFS list identified as [<CustomerFacingService.Id>]
And the network event status is [<NetworkEvent.status>]
And Resource To Service API has a set of Services associated with the identifiers of [<CustomerFacingService.Id overlapping>] that is a subset of the
When Impact Server receives this Network Event
And retrieves service information from the Resource To Service API
Then a new Service Events are created in Netcool-Omnibus related to the service [<CustomerFacingService.Id overlapping>]
And the Service Event is associated with Resource [<ServiceSpecCharacteristic.Switch-HostName>]
And a Service Event created notification is published.
Examples:
| ServiceEvent.Id | ServiceSpecCharacteristic.Switch-HostName | CustomerFacingService.Id | CustomerFacingService.Id overlapping | NetworkEvent.status |
| ServiceEvent123 | Switch123                                 | LAN1,LAN2                | LAN2,LAN3                            | Down                |

@Component: Impact
@Exception
@PreviousServiceEvent:False
@ServiceEvent:Created
@ServiceEvent:Updated
@ImpactedCustomers:Single
Scenario Outline: The Resource To Service API is offline so the Network Event is not completed.
Given Router [<ServiceSpecCharacteristic.Router-HostName>] has failed and raised a Network Event that is available in Netcool
And there is no previous Service Event identifed for this resource
And the network event status is [<NetworkEvent.status>]
And there is no service information in the Network Event
And Resource To Service API is offline
When Impact Server receives this Network Event
Then Impact Server invokes the Resource To Service API
And receives and error response
And the Network Event is marked as imcomplete in Netcool-Omnibus
And there is no Service Event api invocation
And there is no Incident raised

Examples:
| ServiceSpecCharacteristic.Router-HostName | NetworkEvent.status |
| Host123                                    | Down               |


@Component: Fusion
@ServiceEvent:Created
Scenario Outline: When a Notification is provided by Impact Server this is routed to AO
Given The Service Event consumer and provider queues have been created
And the fusion components to relay messages has been deployed
When a Service Event notification is published to the Service Event provider queue
Then the notification is delivered to the Service Event consumer queue
And the message is syntactically equivalent to the original notification.

@Component: Fusion
@IncidentEvent:Created
Scenario Outline: When a Notification is provided by Atrium this is routed to Impact
Given The Incident Event consumer and provider queues have been created
And the fusion components to relay messages has been deployed
When a Incident Event notification is published to the Incident provider queue
Then the notification is delivered to the Incident consumer queue
And the message is syntactically equivalent to the original notification.


@Component: AO
@FailureComponent:Primary
@PreviousServiceEvent:False
@ServiceEvent:Created
Scenario Outline: When a Service Event created is received an Incident is created
Given A Service Event notification has been published to the Service Event consumer queue
And this event is identified as [<ServiceEvent.id>]
And this event references the Resource [ServiceSpecCharacteristic.Router-HostName] that is reporting a failure
And the Service Event references a set of customer facing services [<CustomerFacingService.Id>]
And there are customer CI relates to the CFS CIs in eRemedy with identifiers [<Customer.Id>]
When the notification is received
Then a master technical incident is raised
And the customer CIs for each CFS are determined
And for each CFS an associated child Service Incident is created with reference to the the master technical incident
And an Incident notification is published to the Incident provider queue
And contains a reference to the master technical incident
And the notification contains the Service Event identifier [<ServiceEvent.id>]
And a subsequent query to the Atrium Workflow statistics or details services with a customer identifier of [<Customer.Id>] will reflect the new Service Incidents

Examples:
| ServiceEvent.id | ServiceSpecCharacteristic.Router-HostName | CustomerFacingService.Id | Service Event status | Customer.Id  |
| ServiceEvent1   | Host123                                   | PIP123,PIP234            | Down                 |  1-7MWK-3013 |
