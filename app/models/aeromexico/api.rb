require 'xmlsimple'

module Aeromexico
  class Api

    def flights(params)
        departure_airport = Airport.like_location_and_iata(params['search-flying-from']).first
        return Aeromexico::Response.new([], ["Airport name or destination not found for #{params['search-flying-from']}."]) unless departure_airport

        arrival_airport = Airport.like_location_and_iata(params['search-flying-to']).first
        return Aeromexico::Response.new([], ["Airport name or destination not found for #{params['search-flying-to']}."]) unless arrival_airport

        data = Aeromexico::Utils.prepare_for_flights(departure_airport, arrival_airport, params)


      if SpreeTravelDemo4::Application.config.mode_offline
        # body = File.read('project/aeromexico/flights.json')
        c =
        b = {"PricedItineraries"=>[{"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>109, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T07:05:00", "ArrivalDateTime"=>"2015-05-20T07:54:00", "FlightNumber"=>1195, "OperatingAirline"=>{"FlightNumber"=>1195, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>109}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>98, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T08:51:00", "ArrivalDateTime"=>"2015-05-22T11:29:00", "FlightNumber"=>1196, "OperatingAirline"=>{"FlightNumber"=>1196, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>98}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>5, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>109, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T07:05:00", "ArrivalDateTime"=>"2015-05-20T07:54:00", "FlightNumber"=>1195, "OperatingAirline"=>{"FlightNumber"=>1195, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>109}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>100, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T13:20:00", "ArrivalDateTime"=>"2015-05-22T16:00:00", "FlightNumber"=>2422, "OperatingAirline"=>{"FlightNumber"=>2422, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>100}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>2, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>109, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T07:05:00", "ArrivalDateTime"=>"2015-05-20T07:54:00", "FlightNumber"=>1195, "OperatingAirline"=>{"FlightNumber"=>1195, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>109}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>100, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T14:30:00", "ArrivalDateTime"=>"2015-05-22T17:10:00", "FlightNumber"=>1536, "OperatingAirline"=>{"FlightNumber"=>1536, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>100}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>4, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>109, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T07:05:00", "ArrivalDateTime"=>"2015-05-20T07:54:00", "FlightNumber"=>1195, "OperatingAirline"=>{"FlightNumber"=>1195, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>109}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>102, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T12:05:00", "ArrivalDateTime"=>"2015-05-22T14:47:00", "FlightNumber"=>1157, "OperatingAirline"=>{"FlightNumber"=>1157, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>102}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>6, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>109, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T07:05:00", "ArrivalDateTime"=>"2015-05-20T07:54:00", "FlightNumber"=>1195, "OperatingAirline"=>{"FlightNumber"=>1195, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>109}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>98, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T19:20:00", "ArrivalDateTime"=>"2015-05-22T21:58:00", "FlightNumber"=>158, "OperatingAirline"=>{"FlightNumber"=>158, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>98}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>3, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>109, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T07:05:00", "ArrivalDateTime"=>"2015-05-20T07:54:00", "FlightNumber"=>1195, "OperatingAirline"=>{"FlightNumber"=>1195, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>109}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>95, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T06:00:00", "ArrivalDateTime"=>"2015-05-22T08:35:00", "FlightNumber"=>2446, "OperatingAirline"=>{"FlightNumber"=>2446, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>95}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>1, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>118, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T10:00:00", "ArrivalDateTime"=>"2015-05-20T10:58:00", "FlightNumber"=>1157, "OperatingAirline"=>{"FlightNumber"=>1157, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>118}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>100, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T13:20:00", "ArrivalDateTime"=>"2015-05-22T16:00:00", "FlightNumber"=>2422, "OperatingAirline"=>{"FlightNumber"=>2422, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>100}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>9, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>118, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T10:00:00", "ArrivalDateTime"=>"2015-05-20T10:58:00", "FlightNumber"=>1157, "OperatingAirline"=>{"FlightNumber"=>1157, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>118}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>100, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T14:30:00", "ArrivalDateTime"=>"2015-05-22T17:10:00", "FlightNumber"=>1536, "OperatingAirline"=>{"FlightNumber"=>1536, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>100}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>10, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>118, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T10:00:00", "ArrivalDateTime"=>"2015-05-20T10:58:00", "FlightNumber"=>1157, "OperatingAirline"=>{"FlightNumber"=>1157, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>118}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>95, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T06:00:00", "ArrivalDateTime"=>"2015-05-22T08:35:00", "FlightNumber"=>2446, "OperatingAirline"=>{"FlightNumber"=>2446, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>95}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>8, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}, {"AirItinerary"=>{"OriginDestinationOptions"=>{"OriginDestinationOption"=>[{"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"MIA"}, "ArrivalAirport"=>{"LocationCode"=>"CUN"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-5}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>118, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-20T10:00:00", "ArrivalDateTime"=>"2015-05-20T10:58:00", "FlightNumber"=>1157, "OperatingAirline"=>{"FlightNumber"=>1157, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-4}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>118}, {"FlightSegment"=>[{"DepartureAirport"=>{"LocationCode"=>"CUN"}, "ArrivalAirport"=>{"LocationCode"=>"MIA"}, "MarketingAirline"=>{"Code"=>"US"}, "ArrivalTimeZone"=>{"GMTOffset"=>-4}, "TPA_Extensions"=>{"eTicket"=>{"Ind"=>true}}, "StopQuantity"=>0, "ElapsedTime"=>98, "ResBookDesigCode"=>"G", "MarriageGrp"=>"O", "Equipment"=>{"AirEquipType"=>738}, "DepartureDateTime"=>"2015-05-22T19:20:00", "ArrivalDateTime"=>"2015-05-22T21:58:00", "FlightNumber"=>158, "OperatingAirline"=>{"FlightNumber"=>158, "Code"=>"AA"}, "DepartureTimeZone"=>{"GMTOffset"=>-5}, "DisclosureAirline"=>{"Code"=>"AA"}}], "ElapsedTime"=>98}]}, "DirectionInd"=>"Return"}, "TPA_Extensions"=>{"ValidatingCarrier"=>{"Code"=>"US"}}, "SequenceNumber"=>7, "AirItineraryPricingInfo"=>{"PTC_FareBreakdowns"=>{"PTC_FareBreakdown"=>{"FareBasisCodes"=>{"FareBasisCode"=>[{"BookingCode"=>"G", "DepartureAirportCode"=>"MIA", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"CUN", "content"=>"GLX7M2O1"}, {"BookingCode"=>"G", "DepartureAirportCode"=>"CUN", "AvailabilityBreak"=>true, "ArrivalAirportCode"=>"MIA", "content"=>"GLX7M2O1"}]}, "PassengerTypeQuantity"=>{"Quantity"=>1, "Code"=>"ADT"}, "PassengerFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "Amount"=>469.83}, "Taxes"=>{"TotalTax"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>115.83}, "Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"US2", "Amount"=>"35.40"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"YC", "Amount"=>"5.50"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XY", "Amount"=>"7.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XA", "Amount"=>"5.00"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"AY", "Amount"=>"5.60"}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XD", "Amount"=>30.55}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"UK", "Amount"=>22.28}, {"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"XF", "Amount"=>"4.50"}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}}, "FareInfos"=>{"FareInfo"=>[{"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}, {"TPA_Extensions"=>{"Cabin"=>{"Cabin"=>"Y"}, "SeatsRemaining"=>{"BelowMin"=>false, "Number"=>4}}, "FareReference"=>"G"}]}, "TPA_Extensions"=>{"DivideInParty"=>{"Indicator"=>false}}, "ItinTotalFare"=>{"FareConstruction"=>{"CurrencyCode"=>"NUC", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "TotalFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>469.83}, "Taxes"=>{"Tax"=>[{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "TaxCode"=>"TOTALTAX", "Amount"=>115.83}]}, "BaseFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}, "EquivFare"=>{"CurrencyCode"=>"USD", "DecimalPlaces"=>2, "Amount"=>"354.00"}}}, "TicketingInfo"=>{"TicketType"=>"eTicket"}}], "ReturnDateTime"=>"2015-05-22", "DepartureDateTime"=>"2015-05-20", "DestinationLocation"=>"CUN", "OriginLocation"=>"MIA", "Links"=>[{"rel"=>"self", "href"=>"https://api.test.sabre.com/v1/shop/flights?departuredate=2015-05-20&destination=CUN&eticketsonly=n&limit=10&offset=1&onlineitinerariesonly=N&order=asc&order2=asc&origin=MIA&pointofsalecountry=US&returndate=2015-05-22&sortby=totalfare&sortby2=departuretime"}, {"rel"=>"linkTemplate", "href"=>"https://api.test.sabre.com/v1/shop/flights?origin=<origin>&destination=<destination>&departuredate=<departuredate>&returndate=<returndate>&offset=<offset>&limit=<limit>&sortby=<sortby>&order=<order>&sortby2=<sortby2>&order2=<order2>&minfare=<minfare>&maxfare=<maxfare>&includedcarriers=<includedcarriers>&excludedcarriers=<excludedcarriers>&outboundflightstops=<outboundflightstops>&inboundflightstops=<inboundflightstops>&outboundstopduration=<outboundstopduration>&inboundstopduration=<inboundstopduration>&outbounddeparturewindow=<outbounddeparturewindow>&outboundarrivalwindow=<outboundarrivalwindow>&inbounddeparturewindow=<inbounddeparturewindow>&inboundarrivalwindow=<inboundarrivalwindow>&onlineitinerariesonly=<onlineitinerariesonly>&eticketsonly=<eticketsonly>&includedconnectpoints=<includedconnectpoints>&excludedconnectpoints=<excludedconnectpoints>&pointofsalecountry=<pointofsalecountry>&passengercount=<passengercount>"}]}


        a = {
            "PricedItineraries"=> {
                "AirItinerary"=> {
                    "OriginDestinationOptions"=> {
                        "OriginDestinationOption"=> [{
                             "FlightSegment"=> [{
                                  "DepartureAirport"=> {
                                      "LocationCode"=> "JFK"
                                  },
                                  "ArrivalAirport"=> {
                                      "LocationCode"=> "LAX"
                                  },
                                  "MarketingAirline"=> {
                                      "Code"=> "DL"
                                  },
                                  "ArrivalTimeZone"=> {
                                      "GMTOffset"=> -7
                                  },
                                  "TPA_Extensions"=> {
                                      "eTicket"=> {
                                          "Ind"=> true
                                      }
                                  },
                                  "StopQuantity"=> 0,
                                  "ElapsedTime"=> 370,
                                  "ResBookDesigCode"=> "T",
                                  "MarriageGrp"=> "O",
                                  "Equipment"=> {
                                      "AirEquipType"=> "76W"
                                  },
                                  "DepartureDateTime"=> "2015-06-15T07:20:00",
                                  "ArrivalDateTime"=> "2015-06-15T10:30:00",
                                  "FlightNumber"=> 424,
                                  "OnTimePerformance"=> {
                                      "Level"=> 5
                                  },
                                  "OperatingAirline"=> {
                                      "FlightNumber"=> 424,
                                      "Code"=> "DL"
                                  },
                                  "DepartureTimeZone"=> {
                                      "GMTOffset"=> -4
                                  }
                            }],
                               "ElapsedTime"=> 370
                           }, {
                               "FlightSegment"=> [{
                                    "DepartureAirport"=> {
                                        "LocationCode"=> "LAX"
                                    },
                                    "ArrivalAirport"=> {
                                        "LocationCode"=> "JFK"
                                    },
                                    "MarketingAirline"=> {
                                        "Code"=> "DL"
                                    },
                                    "ArrivalTimeZone"=> {
                                        "GMTOffset"=> -4
                                    },
                                    "TPA_Extensions"=> {
                                        "eTicket"=> {
                                            "Ind"=> true
                                        }
                                    },
                                    "StopQuantity"=> 0,
                                    "ElapsedTime"=> 343,
                                    "ResBookDesigCode"=> "U",
                                    "MarriageGrp"=> "O",
                                    "Equipment"=> {
                                        "AirEquipType"=> "75W"
                                    },
                                    "DepartureDateTime"=> "2015-06-30T12:15:00",
                                    "ArrivalDateTime"=> "2015-06-30T20:58:00",
                                    "FlightNumber"=> 920,
                                    "OnTimePerformance"=> {
                                        "Level"=> 3
                                    },
                                    "OperatingAirline"=> {
                                        "FlightNumber"=> 920,
                                        "Code"=> "DL"
                                    },
                                    "DepartureTimeZone"=> {
                                        "GMTOffset"=> -7
                                    }
                                }],
                               "ElapsedTime"=> 343
                           }]
                    },
                    "DirectionInd"=> "Return"
                },
                "TPA_Extensions"=> {
                    "ValidatingCarrier"=> {
                        "Code"=> "DL"
                    }
                },
                "SequenceNumber"=> 1,
                "AirItineraryPricingInfo"=> {
                    "PTC_FareBreakdowns"=> {
                        "PTC_FareBreakdown"=> {
                            "FareBasisCodes"=> {
                                "FareBasisCode"=> [{
                                       "BookingCode"=> "T",
                                       "DepartureAirportCode"=> "JFK",
                                       "AvailabilityBreak"=> true,
                                       "ArrivalAirportCode"=> "LAX",
                                       "content"=> "TA21A0NP"
                                   }, {
                                       "BookingCode"=> "U",
                                       "DepartureAirportCode"=> "LAX",
                                       "AvailabilityBreak"=> true,
                                       "ArrivalAirportCode"=> "JFK",
                                       "content"=> "UA21A0VP"
                                   }]
                            },
                            "PassengerTypeQuantity"=> {
                                "Quantity"=> 1,
                                "Code"=> "ADT"
                            },
                            "PassengerFare"=> {
                                "FareConstruction"=> {
                                    "CurrencyCode"=> "USD",
                                    "DecimalPlaces"=> 2,
                                    "Amount"=> 368.37
                                },
                                "TotalFare"=> {
                                    "CurrencyCode"=> "USD",
                                    "Amount"=> "424.20"
                                },
                                "Taxes"=> {
                                    "TotalTax"=> {
                                        "CurrencyCode"=> "USD",
                                        "DecimalPlaces"=> 2,
                                        "Amount"=> 55.83
                                    },
                                    "Tax"=> [{
                                           "CurrencyCode"=> "USD",
                                           "DecimalPlaces"=> 2,
                                           "TaxCode"=> "US1",
                                           "Amount"=> 27.63
                                       }, {
                                           "CurrencyCode"=> "USD",
                                           "DecimalPlaces"=> 2,
                                           "TaxCode"=> "ZP",
                                           "Amount"=> "8.00"
                                       }, {
                                           "CurrencyCode"=> "USD",
                                           "DecimalPlaces"=> 2,
                                           "TaxCode"=> "AY",
                                           "Amount"=> "11.20"
                                       }, {
                                           "CurrencyCode"=> "USD",
                                           "DecimalPlaces"=> 2,
                                           "TaxCode"=> "XF",
                                           "Amount"=> "9.00"
                                       }]
                                },
                                "BaseFare"=> {
                                    "CurrencyCode"=> "USD",
                                    "Amount"=> 368.37
                                },
                                "EquivFare"=> {
                                    "CurrencyCode"=> "USD",
                                    "DecimalPlaces"=> 2,
                                    "Amount"=> 368.37
                                }
                            }
                        }
                    },
                    "FareInfos"=> {
                        "FareInfo"=> [{
                            "TPA_Extensions"=> {
                                "Cabin"=> {
                                    "Cabin"=> "Y"
                                },
                                "SeatsRemaining"=> {
                                    "BelowMin"=> false,
                                    "Number"=> 4
                                }
                            },
                                "FareReference"=> "T"
                            }, {
                                "TPA_Extensions"=> {
                                    "Cabin"=> {
                                        "Cabin"=> "Y"
                                    },
                                    "SeatsRemaining"=> {
                                        "BelowMin"=> false,
                                        "Number"=> 4
                                    }
                                },
                                "FareReference"=> "U"
                            }]
                    },
                    "TPA_Extensions"=> {
                        "DivideInParty"=> {
                            "Indicator"=> false
                        }
                    },
                    "ItinTotalFare"=> {
                        "FareConstruction"=> {
                            "CurrencyCode"=> "USD",
                            "DecimalPlaces"=> 2,
                            "Amount"=> 368.37
                        },
                        "TotalFare"=> {
                            "CurrencyCode"=> "USD",
                            "DecimalPlaces"=> 2,
                            "Amount"=> "424.20"
                        },
                        "Taxes"=> {
                            "Tax"=> [{
                                         "CurrencyCode"=> "USD",
                                         "DecimalPlaces"=> 2,
                                         "TaxCode"=> "TOTALTAX",
                                         "Amount"=> 55.83
                                     }]
                        },
                        "BaseFare"=> {
                            "CurrencyCode"=> "USD",
                            "DecimalPlaces"=> 2,
                            "Amount"=> 368.37
                        },
                        "EquivFare"=> {
                            "CurrencyCode"=> "USD",
                            "DecimalPlaces"=> 2,
                            "Amount"=> 368.37
                        }
                    }
                },
                "TicketingInfo"=> {
                    "TicketType"=> "eTicket"
                }
            },
            "ReturnDateTime"=> '2015-06-30',
            "DepartureDateTime"=> '2015-06-15',
            "DestinationLocation"=> 'LAX',
            "OriginLocation"=> "JFK",
            "Links"=> {
                "rel"=> "self",
                "href"=> "https=>//api.test.sabre.com/v1/shop/flights?origin=JFK&destination=LAX&departuredate=2015-06-15&returndate=2015-06-30&onlineitinerariesonly=N&limit=1&offset=1&eticketsonly=N&sortby=totalfare&order=asc&sortby2=departuretime&order2=asc&pointofsalecountry=US"
            }
        }

        flights = Aeromexico::Utils.parse_flights(b, params, data)
        return Aeromexico::Response.new(flights)
      else

        if params['search-flight-type'].blank? or params['search-flying-from'].blank? or
           params['search-flying-to'].blank? or params['search-departing-date'].blank?
          return Aeromexico::Response.new([], ['There is not enough information to verify availability of flights.'])
        end

        begin
          response = Aeromexico::HTTPService.make_request('/v1/shop/flights', data)
        rescue StandardError => e
          return Aeromexico::Response.new([], [e.to_s])
        else
          body = JSON.parse(response.body)
        end

        if body['Error']
          return Aeromexico::Response.new([], body['Error'].first['Description'])
        end

        flights = Aeromexico::Utils.parse_flights(body, params, data)
        Aeromexico::Response.new(flights)

      end
    end

  end
end
