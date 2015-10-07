module Sample

  class Flight

    @flight_ways=['One way flight', 'Two way flight']
    @fligh_types=['Business', 'First Class', 'Economy', 'Premium Economy']
    @inflight_features=['Available', 'Not Available']
    @airlines=['Major Airline', 'United Airlines', 'Delta Airlines', 'Alitalia', 'US airways', 'Air France', 'Air tahiti nui', 'American Airlines', 'Copa Airlines']
    ##  to change the style of the icon add circle at the end. Example: soap-icon-entertainment circle
    @features={'WIFI' => 'soap-icon-wifi',
               'entertainment' => 'soap-icon-entertainment',
               'television' => 'soap-icon-entertainment',
               'entertainment' => 'soap-icon-television',
               'air conditioning' => 'soap-icon-aircon',
               'drink' => 'soap-icon-juice',
               'games' => 'soap-icon-joystick',
               'coffee' => 'soap-icon-coffee',
               'wines' => 'soap-icon-winebar',
               'shopping' => 'soap-icon-shopping',
               'food' => 'soap-icon-food',
               'comfort' => 'soap-icon-comfort',
               'magazines' => 'soap-icon-magazine'
    }
    class << self

      def generate_flight
        f = OpenStruct.new
        f.flight_way=@flight_ways.sample
        f.flight_type=@fligh_types.sample
        f.name = Faker::Address.country + ' - '+ Faker::Address.country

        takeoff=generate_date
        flight_duration=rand(3600...86400)
        landing=takeoff+flight_duration

        f.takeOff= takeoff.strftime('%d %b %Y,%I:%M %p')
        f.landing=landing.strftime('%d %b %Y,%I:%M %p')
        f.duration=(flight_duration/3600).to_s+'H '+((flight_duration%3600)/60).to_s+' M'
        f.duration_long_style=(flight_duration/3600).to_s+'Hours,'+((flight_duration%3600)/60).to_s+' Minutes'

        f.airline= @airlines.sample
        f.cancellation='$'+rand(40...200).to_s+'/person' #$78 / person
        f.flight_change='$'+rand(40...200).to_s+'/person' #$78 / person
        f.seat_baggage='$'+rand(40...200).to_s+'/person' #$78 / person

        f.inflight_features=@inflight_features.sample
        f.base_fare='$'+rand(300...900).to_s #$320.00
        f.taxes_fees='$'+rand(300...900).to_s #$320.00
        f.total_price='$'+rand(300...900).to_s #$320.00
        f.long_description=Faker::Lorem.paragraph(5)
        f.lay_over=rand(1...4).to_s+'h '+rand(5...50).to_s+'m' #3h 50m
        f.short_description=Faker::Lorem.sentence
        f.airline_description=Faker::Lorem.paragraph(10)
        f.calendar_description=Faker::Lorem.paragraphs(1)
        f.identifier=f.airline[0]+f.airline[1]+' - '+rand(100...999).to_s+ ' '+f.flight_type
        f.list_of_features_flight=@features
        f
      end

      def sample
        @@_flights ||=
            begin
              flights= []
              sample_size=10
              sample_size.times do
                flights << generate_flight
              end
              flights
            end
      end

      def airlines
        @airlines
      end

      def generate_date

        timeOff= Time.now+rand(0...864000)

      end

    end


  end
end