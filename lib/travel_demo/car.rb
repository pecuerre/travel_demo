module Sample

  class Car

    @car_types=['Full size', 'Compact', 'Economy', 'Luxury/Premium', 'Minicar', 'Van/Minivan', 'Exotic/Special']
    @car_names=['Audi A3 cabriole', 'Bmw 5 series', 'Holden sv6', 'Fiat 500',
                'Renault grand scenic', 'vokswagen polo diesel',
                'Renault clio', 'Nissan tiida',
                'Mitsubishi pajero', 'Toyota camry', 'Toyota landcruiser',
                'Toyota auris']
    @car_features=['Available', 'Not Available']
    ##  to change the style of the icon add circle at the end. Example: soap-icon-entertainment circle
    @features={'Passengers' => 'soap-icon-user circle',
               'Bags' => 'soap-icon-suitcase circle',
               'air conditioning' => 'soap-icon-aircon circle',
               'Satellite Navigation' => 'soap-icon-fmstereo circle',
               'Disel Vehicle' => 'soap-icon-fueltank circle',
               'Automatic transmission' => 'soap-icon-automatic-transmission circle'
    }


    class << self

      def generate_car
        c = OpenStruct.new
        c.rental_company=Faker::Company.name
        c.car_type=@car_types.sample
        c.car_name=@car_names.sample
        c.passenger=rand(2...7)
        c.baggage=rand(2...7)
        c.features=@car_features.sample

        c.taxes_fees="$ #{rand(300...900)}"
        c.total_price="$ #{rand(300...900)}"
        c.per_day="$ #{rand(20...60)}"
        c.damage="$ #{rand(20...200)}"
        c.phone=Faker::PhoneNumber.phone_number

        pick_off=generate_date
        travel_duration=rand(3600...86400)
        drop_off=pick_off+travel_duration

        c.pick_off= pick_off.strftime('%d %b %Y | %I:%M %p')
        c.drop_off=drop_off.strftime('%d %b %Y | %I:%M %p')
        c.pick_off_date= pick_off.strftime('%d %b %Y')
        c.drop_off_date=drop_off.strftime('%d %b %Y')
        c.pick_off_short=pick_off.strftime('%I:%M %p')
        c.drop_off_short=drop_off.strftime('%I:%M %p')

        c.location=Faker::Address.city
        c.drop_location=Faker::Address.city
        c.rental_information=Faker::Lorem.paragraphs(3)

        c.mileage="#{rand(1000...10000)} Miles"
        c.description=Faker::Lorem.paragraphs(1)
        c.list_of_features_car=@features
        c
      end

      def sample
        @@_cars ||=
            begin
              cars= []
              sample_size=10
              sample_size.times do
                cars << generate_car
              end
              cars
            end
      end

      def car_types
        @car_types
      end

      def generate_date

        timeOff= Time.now+rand(0...864000)

      end

    end


  end
end