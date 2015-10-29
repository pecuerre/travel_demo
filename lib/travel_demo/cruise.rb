module Sample

  class Cruise

    @cruises_names=['Carnival', 'Royal Caribean', 'Mediterranean trip', 'Big Ilands', 'Caribean Rinmbows', 'Horizon Colors', 'Summer trip', 'Great Caribbean and antilles']
    @ship_names=['Imagination', 'Siloshius', 'New Titanic', 'Charles III', 'Princess of Sea', 'Triton', 'Speed', 'Oceans Queen', 'Litle Beauty', 'Mermaid', 'Athenas', 'Free Bird']

    @room_types=['Grand Suite', 'Junior Suite', 'Junior Suite (obstructed view)', 'Small Suite', 'Just Married Suite']
    @flight_types=['Business', 'First Class', 'Economy', 'Premium Economy']
    @inflight_features=['Available', 'Not Available']
    @airlines=['Major Airline', 'United Airlines', 'Delta Airlines', 'Alitalia', 'US airways', 'Air France', 'Air tahiti nui', 'American Airlines', 'Copa Airlines']
    ##  to change the style of the icon add circle at the end. Example: soap-icon-entertainment circle
    @features={'WIFI' => 'soap-icon-wifi circle',
               'entertainment' => 'soap-icon-entertainment circle',
               'television' => 'soap-icon-entertainment circle',
               'entertainment' => 'soap-icon-television circle',
               'air conditioning' => 'soap-icon-aircon circle',
               'drink' => 'soap-icon-juice circle',
               'games' => 'soap-icon-joystick circle',
               'coffee' => 'soap-icon-coffee circle',
               'wines' => 'soap-icon-winebar circle',
               'shopping' => 'soap-icon-shopping circle',
               'food' => 'soap-icon-food circle',
               'comfort' => 'soap-icon-comfort circle',
               'magazines' => 'soap-icon-magazine circle',
               'swimming pool' => 'soap-icon-swimming',
               'fitness facility' => 'soap-icon-fitnessfacility',
               'fridge' => 'soap-icon-fridge',
               'smoking allowed' => 'soap-icon-swimming',
               'secure vault' => 'soap-icon-securevault',
               'pick and drop' => 'soap-icon-pickanddrop',
               'pets allowed' => 'soap-icon-pets',
               'Handicap Accessible' => 'soap-icon-handicapaccessiable',


    }


    class << self

      def generate_cruise
        c = OpenStruct.new
        c.cruise_name=@cruises_names.sample
        c.days=rand(3...7)
        c.cruise_length="#{c.days} nights"
        c.ship_name = @ship_names.sample
        c.interior_room="$ #{rand(100...300)}"
        c.ocean_view="$ #{rand(100...300)}"
        c.balcony="$ #{rand(100...300)}"
        c.suite="$ #{rand(100...300)}"
        c.save_per_room="#{rand(5...50)}%"
        c.itinerary=generate_itinerary(c.days)
        c.description=Faker::Lorem.paragraphs(3)
        c.rooms=[]
        rand(10...15).times { c.rooms<<generate_room }

        keys = @features.keys.to_a
        set = Set.new
        6.times { set << keys.sample }
        hash = @features.select { |key, _| set.include?(key) }

        c.amenities=hash


        takeoff=generate_date
        flight_duration=rand(3600...86400)
        landing=takeoff+flight_duration

        c.takeOff= takeoff.strftime('%d %b %Y,%I:%M %p')
        c.landing=landing.strftime('%d %b %Y,%I:%M %p')
        c.duration="#{(flight_duration/3600)} H #{(flight_duration%3600)/60} M"
        c.duration_long_style="#{(flight_duration/3600)} Hours #{(flight_duration%3600)/60} Minutes"

        c.airline= @airlines.sample
        c.cancellation="$ #{rand(40...200)} /person"
        c.flight_change="$ #{rand(40...200)} /person"
        c.seat_baggage="$ #{rand(40...200)} /person"

        keys = @features.keys.to_a
        set = Set.new
        5.times { set << keys.sample }
        hash = @features.select { |key, _| set.include?(key) }


        c.inflight_features=@inflight_features.sample
        c.base_fare="$ #{rand(300...900)}"
        c.taxes_fees="$ #{rand(300...900)}"
        c.total_price="$ #{rand(300...900)}"
        c.long_description=Faker::Lorem.paragraph(5)
        c.lay_over="#{rand(1...4)} h #{rand(5...50)} m"
        c.short_description=Faker::Lorem.sentence
        c.airline_description=Faker::Lorem.paragraph(10)
        c.calendar_description=Faker::Lorem.paragraphs(1)
        c.identifier="#{c.airline[0]} #{c.airline[1]} - #{rand(100...999)} #{c.flight_type}"
        c.list_of_features_flight=hash
        c.features_description=Faker::Lorem.paragraphs(1)
        c.sets_selection_description=Faker::Lorem.paragraphs(1)

        c.countries=Faker::Address.country
        c
      end

      def generate_trip(day)
        t= OpenStruct.new
        t.day=day
        t.port_call="#{Faker::Address.city} port"

        pick_off=generate_date
        travel_duration=rand(3600...86400)
        drop_off=pick_off+travel_duration

        t.pick_off= pick_off.strftime('%d %b %Y | %I:%M %p')
        t.drop_off=drop_off.strftime('%d %b %Y | %I:%M %p')
        t.pick_off_date= pick_off.strftime('%d %b %Y')
        t.drop_off_date=drop_off.strftime('%d %b %Y')
        t.pick_off_short=pick_off.strftime('%I:%M %p')
        t.drop_off_short=drop_off.strftime('%I:%M %p')

        t.arrival=t.drop_off_short
        t.departure=t.pick_off_short
        t
      end

      def generate_room
        r= OpenStruct.new
        r.room_type=@room_types.sample
        r.description=Faker::Lorem.paragraphs(1)
        r.price="$ #{rand(100...200)}"
        r.deck=['UPPER', 'Verandah'].sample
        r.size="#{rand(100...500)} sq ft Balcony: #{rand(50...100)} sq ft"

        keys = @features.keys.to_a
        set = Set.new
        6.times { set << keys.sample }
        hash = @features.select { |key, _| set.include?(key) }

        r.features=hash
        r
      end

      def generate_itinerary(duration)

        trips= []
        sample_size=duration
        i = 1
        until i == sample_size do
          trips << generate_trip(i)
          i += 1
        end
        trips

      end

      def sample
        @@_cruices ||=
            begin
              cruises= []
              sample_size=10
              sample_size.times do
                cruises << generate_cruise
              end
              cruises
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