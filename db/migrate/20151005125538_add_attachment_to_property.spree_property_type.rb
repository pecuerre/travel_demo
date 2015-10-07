# This migration comes from spree_property_type (originally 20130806210405)
class AddAttachmentToProperty < ActiveRecord::Migration

  def up
    add_attachment :spree_properties, :icon
  end

  def down
    remove_attachment :spree_properties, :icon
  end
end
