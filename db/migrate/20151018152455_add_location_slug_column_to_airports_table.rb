class AddLocationSlugColumnToAirportsTable < ActiveRecord::Migration
  def change
    unless column_exists? :airports, :location_slug
      add_column :airports, :location_slug, :string
    end
  end
end
