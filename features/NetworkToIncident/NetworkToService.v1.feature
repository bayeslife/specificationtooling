@NetworkToIncident
Feature: Reify Service Event

As a customer
I want to have visibility of Network Outage Events that may have effected my Services
so that I am confident that Vodafone will be aware of service outages without having to raise Incidents myself.

As a resolver
I want to have Incidents raised to myself that are raised to the correct resolver team and are only raised once for each root cause
so that I dont have to waste time modifying multiple Incidents for a single root cause.

@PrimaryComponentFailureNetworkEvent
@ServiceInformationNotAvailable
@CreateServiceEvent
Scenario Outline: A failing primary device with no associated avaialable service information will create an new Service Event
Given A router <ServiceSpecCharacteristic.Router-HostName> has failed and raised a Network Event that is available in Netcool
And the network event status is <NetworkEvent.status>
And Resource To Service API has no corresponding Services
When impact server receives this Network Event
And there is no previous service event identifed for this resource
Then a service event api is invoked
And the correlation event guid is generated
And there is no service information provided

Examples:
| ResourceSpecCharacteristic.Router-HostName | NetworkEvent.status |
| Host123                                    | Down                |

@PrimaryComponentFailureNetworkEvent
@ServiceInformationNotAvailable
@Flappling
@UpdateServiceEvent
Scenario Outline: A flapping primary or secondary device failure event raises no further Service Event
Given A router <ServiceSpecCharacteristic.Router-HostName> has failed and raised a Network Event that is available in Netcool
And the network event status is <NetworkEvent.status>
And Resource To Service API has no corresponding Services
And a previous event was identified as <ServiceEvent.id> was received within the frequency tolerance from the same device
When impact server receives this Network Event
Then no service event api is invoked
And the Service Event is updated with count of failing Network Events.

Examples:
| ResourceSpecCharacteristic.Router-HostName | ServiceEvent.id  | NetworkEvent.status  |
| Host123                                    | ServiceEvent1234 | Down                 |

@PrimaryComponentFailureNetworkEvent
@SecondaryComponentFailureNetworkEvent
@ServiceInformationNotAvailable
@ServiceInformationAvailable
Scenario Outline: A network primary device up event results in an invocation of the Service Event API after the tolerance period
Given A router <ServiceSpecCharacteristic.Router-HostName> has generated a resource up status identified as <NetworkEvent.status>
And a new Network Event that is available in Netcool
And Resource To Service API has no an association to services
And Impact Server previously generated a Service Event identified as <ServiceEvent.id>
And there have been no subsequent Network events for a period of the Configured Service Event Frequency Tolerance
When the Configured Service Event Frequency Tolerance period is exceeded
Then the Service Event api is invoked
And the Service Event id is <ServiceEvent.id>
And the Service Up status is identified as <ServiceEvent.status>
And the ServiceEvent is considered complete

Examples:
| ResourceSpecCharacteristic.Router-HostName | ResourceSpecCharacteristic.Router-Type |  NetworkEvent.status | ServiceEvent.id| ServiceEvent.status |
| Host123                                    | Huawei  HG659                          |  Up                  | ServiceEvent123| Service Up          |



@SecondaryComponentFailureNetworkEvent
@ServiceInformationNotAvailable
@CreateServiceEvent
Scenario Outline: A failing secondary device with no associated Service will create a duplicate Incident
Given A router <ServiceSpecCharacteristic.Router-HostName> has failed and raised a Network Event that is available in Netcool
And the network event status is <NetworkEvent.status>
And Resource To Service API has no corresponding Services
When impact server receives this Network Event
And there is no previous service event identifed for this resource
Then a service event api is invoked
And the correlation event guid is generated
And there is no service information provided


@PrimaryComponentFailureNetworkEvent
@ServiceInformationAvailable
@CreateServiceEvent
Scenario Outline: A newly failing primary compoennts associated with a specific customer and service
Given A router <ServiceSpecCharacteristic.Router-HostName> has generated a <NetworkEvent.status> and raised a Network Event that is available in Netcool
And Resource To Service API has an association from the router to the CFS <CustomerFacingService.Id> and customer <Customer.crmId>
And Impact Server has no previous incomplete Service Event for the Network resource
When impact server receives this Network Event
Then the Service Event api is invoked
And the service event id is generated
And the primary service is identified by name <CustomerFacingService.Id>
And the crmId is identified as <Customer.crmId>
And the CFS Service status is identified as <ServiceEvent.status>

Examples:
| ResourceSpecCharacteristic.Router-HostName | ResourceSpecCharacteristic.Router-Type |  NetworkEvent.status | CustomerFacingService.Id | Customer.crmId | ServiceEvent.status |
| Host123                                    | Huawei  HG659                          |  Down                | LAN1                     | Customer1      | Service Down        |
| Host456                                    | Ruckus ZoneFlex H500 AP                |  Down                | WIFI1                    | Customer2      | Service Down        |



@SecondaryComponentFailureNetworkEvent
@ServiceInformationAvailable
@UpdateServiceEvent
Scenario Outline: A failing secondary component with available associated Service information
Given A switch providing the LAN has failed and raised a Network Event
And that is available in Netcool and associated with service event <ServiceEvent.id>
And a router <ServiceSpecCharacteristic.Router-HostName> has previously failed and raised a Network Event that is available in Netcool
And the network event status is <NetworkEvent.status>
And Resource To Service API has corresponding Services which are recorded as a RFS related to the router and and RFS related to the switch <RFS.Switch-SwitchLan1>
When impact server receives this Network Event
And retrieves service information from the Resource To Service API
And because one of the services overlaps
Then no service event api is invoked
And the service event is invoked.


@PrimaryComponentFailureNetworkEvent
@SecondaryComponentFailureNetworkEvent
@ServiceInformationAvailable
@MultipleCustomers
@CreateServiceEvent
Scenario Outline: A failing device associated with more than one customer and single service
Given A router <ServiceSpecCharacteristic.Router-HostName> has failed and raised a Network Event that is available in Netcool
And Resource To Service API has an association from the router to the RFS <ResourceFacingService.Id> to customer <Customer.crmId Cust1> and separately to <Customer.crmId CustN>
When Impact Server receives this Network Event
And identifies the need for new Service Events
Then the Service Event api is invoked once
And the Service Events primary service is identified by name <ResourceFacingService.Id>
And service is associated to <Customer.crmId Cust1>
And the another is assoicated to <Customer.crmId CustN>

Examples:
| ResourceSpecCharacteristic.Router-HostName | ResourceSpecCharacteristic.Router-Type |  ResourceFacingService.Id | Customer.crmId Cust1 | Customer.crmId CustN |
| Host123                                    | Huawei  HG659                          |  Router1                  | Customer1            | CustomerN             |



@PrimaryComponentFailureNetworkEvent
@SecondaryComponentFailureNetworkEvent
@ServiceInformationAvailable
@SingleCustomer
@UpdateServiceEvent
Scenario Outline: A failing device associated with more than one service for a single customer
Given A router <ServiceSpecCharacteristic.Router-HostName> has failed and raised a Network Event that is available in Netcool
And this router provides <CustomerFacingService.Id service1> and <CustomerFacingService.Id service2> to customer <Customer.crmId>
And Resource To Service API has an association from the router to the CFS and Customer
And Resource To Service API has a dependency from <ResourceFacingService.Id service1> to <ResourceFacingService.Id service2>
When Impact Server receives this Network Event
Then the service event api is invoked with a single Service Event
And the primary service is identified by name <CustomerFacingService.Id service2>
And the crmId is identified as <Customer.crmId>

Examples:
| ResourceSpecCharacteristic.Router-HostName | ResourceSpecCharacteristic.Router-Type |  CustomerFacingService.Id service1 | CustomerFacingService.Id servivce2 | Customer.crmId Cust2 |
| Host123                                    | Huawei  HG659                          |  WAN1                              | LAN1                               | Customer1            |


@IndependentServices
@CreateServiceEvent
@UpdateServiceEvent
Scenario Outline: A failing device associated with more than one service for a single customer and each service is independent (no CFS interdependencies)
Given A router <ServiceSpecCharacteristic.Router-HostName> has failed and raised a Network Event that is available in Netcool
And this router provides <CustomerFacingService.Id service1> and the independent service <CustomerFacingService.Id serviceN> to customer <Customer.crmId>
And Resource To Service API has an association from the router to the CFS and Customer
And Resource To Service API has returned dependencies that dont overlap
When impact server receives this Network Event
Then the service event api is updated
And the both services are identified as primary services


Examples:
| ResourceSpecCharacteristic.Router-HostName | ResourceSpecCharacteristic.Router-Type |  CustomerFacingService.Id service1 | CustomerFacingService.Id servivce2 | Customer.crmId Cust2 |
| Host123                                    | Huawei  HG659                          |  WAN1                              | LAN2                               | Customer1            |



@Exception
@CreateServiceEvent
@UpdateServiceEvent
Scenario Outline: The Resource To Service API is offline but an Service Event is still created.
Given A router has failed and raised a Network Event that is available in Netcool
And this is the first network event corresponding to this resource
And Resource To Service API is offline
When impact server receives this Network Event
Then a service event api is invoked but no service information is included.
