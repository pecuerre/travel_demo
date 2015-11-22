class CreateDestinationServiceIds < ActiveRecord::Migration
  def up
    create_table :destination_service_ids do |t|
      t.integer :taxon_id
      t.string :service_name
      t.integer :service_destination_id
      t.timestamps
    end
  end

  def down
    drop_table :destination_service_ids
  end

end
