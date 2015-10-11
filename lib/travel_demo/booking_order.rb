module Sample

  class Booking_Order

    class << self

      def sample
        b = OpenStruct.new
        b.booking_number=rand(1000...9999)
        b.first_name=Faker::Name.first_name
        b.last_name = Faker::Name.last_name
        b.email=Faker::Internet.email()
        b.street_address=Faker::Address.street_name
        b.town=Faker::Address.city
        b.zip=Faker::Address.zip_code
        b.country=Faker::Address.country
        b.payment=Faker::Lorem.paragraph(5)
        b.view_details=Faker::Lorem.paragraph(4)
        b
      end

    end


  end
end