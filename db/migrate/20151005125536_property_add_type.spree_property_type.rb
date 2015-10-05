# This migration comes from spree_property_type (originally 20120903024445)
class PropertyAddType < ActiveRecord::Migration
    def up
        add_column :spree_properties, :property_type_id, :integer, :default => nil
    end

    def down
        remove_column :spree_properties, :property_type_id
    end
end
