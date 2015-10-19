class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :iata
      t.string :name
      t.string :icao
      t.string :city
      t.string :country
      t.string :location

      t.timestamps
    end
  end
end
