class AddInitialAirports < ActiveRecord::Migration
  def up
    airports = WorldAirports::Scrapped.instance.all_airports.values.select{|a| a[:country] == 'Mexico'}
    Airport.create(airports)
  end

  def down
    Airport.delete_all
  end
end
