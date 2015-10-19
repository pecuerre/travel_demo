class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :name
      t.integer :price_travel_id
      t.integer :best_day_id

      t.timestamps
    end
  end
end
