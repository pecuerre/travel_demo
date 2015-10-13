require Rails.root + "db/common/trip_functions"
require Rails.root + "db/common/fake_functions"
include TripFunctions
include FakeFunctions

### Configuration Variables
hotels = Spree::Product.hotels
years = 1 # HERE
seasons = 2 # HERE
plans = Spree::OptionType.plans

for hotel in hotels
  puts "Product: #{hotel.name}"
  for room in hotel.variants
    for year in 1..years
      for season in 1..seasons
        for plan in plans
          rate_attrs = {
            :start_date => Date.today + (year - 1) * 365 + (season - 1) * (365 / seasons),
            :end_date => Date.today + (year - 1) * 365 + season * (365 / seasons) - 1,
            :plan => plan.id,
            :simple => get_fake_number(70,100),
            :double => get_fake_number(120,180),
            :triple => get_fake_number(170,260),
            :first_child => get_fake_number(20, 40),
            :second_child => get_fake_number(15, 30)
          }
          rate = Spree::Rate.new
          rate.variant_id = room.id
          rate.first_time!
          rate.save
          rate_attrs.each do |key, value| 
            rate.set_persisted_option_value(key, value)
          end
          rate.save
          puts "  - Rate: #{rate_attrs.values.join(',')}"
        end
      end
    end
  end
end
