# This migration comes from spree_property_type (originally 20130806210406)
class AddPresentationToPropertyType < ActiveRecord::Migration

  def up
    add_column :spree_property_types, :presentation, :string
  end

  def down
    remove_column :spree_property_types, :presentation
  end
end
