class AddNameSlugAndLocationSlugToAirport < ActiveRecord::Migration
  def up
    add_column :airports, :name_slug, :string
    add_column :airports, :location_slug, :string
  end

  def down
    remove_column :airports, :name_slug
    remove_column :airports, :location_slug
  end
end
