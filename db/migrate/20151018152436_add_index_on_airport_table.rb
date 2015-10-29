class AddIndexOnAirportTable < ActiveRecord::Migration
  def change
    add_index :airports, :name
    add_index :airports, :city
    add_index :airports, :location
  end
end
