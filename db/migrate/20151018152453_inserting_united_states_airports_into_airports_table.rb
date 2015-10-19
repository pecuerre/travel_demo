class InsertingUnitedStatesAirportsIntoAirportsTable < ActiveRecord::Migration
  def change
    airports = WorldAirports::Scrapped.instance.all_airports.values.select{|a| a[:country] == 'United States'}
    Airport.create(airports)
  end
end
