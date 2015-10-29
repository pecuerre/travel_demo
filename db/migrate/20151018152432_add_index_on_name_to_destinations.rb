class AddIndexOnNameToDestinations < ActiveRecord::Migration
  def change
    add_index :destinations, :name
  end
end
