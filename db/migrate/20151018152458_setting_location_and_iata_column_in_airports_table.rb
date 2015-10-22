class SettingLocationAndIataColumnInAirportsTable < ActiveRecord::Migration
  def change
    Airport.all.each do |airport|
      airport.location_and_iata = "#{airport.location} (#{airport.iata})"
      airport.save
    end
  end
end
