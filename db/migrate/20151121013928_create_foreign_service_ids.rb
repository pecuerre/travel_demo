class CreateForeignServiceIds < ActiveRecord::Migration
  def up
    create_table :foreign_service_ids do |t|
      t.integer :taxon_id
      t.string :service_name
      t.integer :service_item_id
      t.timestamps
    end
  end

  def down
    drop_table :foreign_service_ids
  end

end
