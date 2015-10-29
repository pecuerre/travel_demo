class AddingLocationAndIataColumnToAirportsTable < ActiveRecord::Migration
  def up
    add_column :airports, :location_and_iata, :string
  end

  def down
    remove_column :airports, :location_and_iata
  end
end
