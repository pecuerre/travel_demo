require Rails.root + "db/common/trip_functions"
include TripFunctions

taxonomies = [
  { :name => "Destination", :position => 1 },
  { :name => "Category", :position => 2 },

  # Taxonomies to be used as parameters in search sessions.
  { :name => "Departure airport", :position => 3 },
  { :name => "Arrival airport", :position => 4 },
  { :name => "Destination city", :position => 5 },
]

taxonomies.each do |taxonomy_attrs|
  create_taxonomy(taxonomy_attrs)
end
