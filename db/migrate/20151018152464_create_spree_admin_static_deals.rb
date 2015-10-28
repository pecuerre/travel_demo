class CreateSpreeAdminStaticDeals < ActiveRecord::Migration
  def change
    create_table :spree_static_deals do |t|
      t.string :name
      t.text :description
      t.float :price
      t.string :link
      t.integer :stars
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at




      t.timestamps
    end
  end
end
