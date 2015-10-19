class AddLinkToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :link, :text, :limit => nil
  end
end
