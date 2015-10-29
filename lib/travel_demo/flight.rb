module Sample

  class Flight

    @flight_ways=['One way flight', 'Two way flight']
    @stops=['1 stop', '2 stops', '3 stops', 'multistops']
    @flight_types=['Business', 'First Class', 'Economy', 'Premium Economy']
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
        f.flight_type=@flight_types.sample
        f.name = Faker::Address.country + ' to '+ Faker::Address.country
        f.stops=@stops.sample

        takeoff=generate_date
        flight_duration=rand(3600...86400)
        landing=takeoff+flight_duration

        f.takeOff= takeoff.strftime('%d %b %Y,%I:%M %p')
        f.landing=landing.strftime('%d %b %Y,%I:%M %p')
        f.duration="#{(flight_duration/3600)} H #{(flight_duration%3600)/60} M"
        f.duration_long_style="#{(flight_duration/3600)} Hours #{(flight_duration%3600)/60} Minutes"

        f.airline= @airlines.sample
        f.cancellation="$ #{rand(40...200)} /person"
        f.flight_change="$ #{rand(40...200)} /person"
        f.seat_baggage="$ #{rand(40...200)} /person"

        keys = @features.keys.to_a
        set = Set.new
        5.times { set << keys.sample }
        hash = @features.select { |key, _| set.include?(key) }


        f.inflight_features=@inflight_features.sample
        f.base_fare="$ #{rand(300...900)}"
        f.taxes_fees="$ #{rand(300...900)}"
        f.total_price="$ #{rand(300...900)}"
        f.long_description=Faker::Lorem.paragraph(5)
        f.lay_over="#{rand(1...4)} h #{rand(5...50)} m"
        f.short_description=Faker::Lorem.sentence
        f.airline_description=Faker::Lorem.paragraph(10)
        f.calendar_description=Faker::Lorem.paragraphs(1)
        f.identifier="#{f.airline[0]} #{f.airline[1]} - #{rand(100...999)} #{f.flight_type}"
        f.list_of_features_flight=hash
        f.features_description=Faker::Lorem.paragraphs(1)
        f.sets_selection_description=Faker::Lorem.paragraphs(1)

        f.number_of_available_seats=rand(1...10)
        seats=[]
        f.number_of_available_seats.times do
          seats<< generate_seat
        end
        f.seats=seats
        f.baggage_information=Faker::Lorem.paragraphs(4)
        f.fare_rules_description=Faker::Lorem.paragraphs(4)


        f.number_of_available_rules=rand(1...10)
        rules=[]
        f.number_of_available_rules.times do
          rules<< generate_rule
        end
        f.rules=rules
        f.countries=Faker::Address.country
        f
      end

      def generate_seat
        s= OpenStruct.new
        s.price='$'+rand(10...20).to_s
        s.description=Faker::Lorem.sentence
        s
      end

      def generate_rule
        r= OpenStruct.new
        r.title=Faker::Lorem.word
        r.description=Faker::Lorem.paragraphs(2)
        r
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

      def stops
        @stops
      end

      def flight_types
        @flight_types
      end

      def features
        @features
      end

      def generate_date

        timeOff= Time.now+rand(0...864000)

      end

    end


  end
end