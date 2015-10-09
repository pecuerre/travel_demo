require Rails.root + "db/common/trip_functions"
include TripFunctions

taxonomies = [
  { :name => "Destination", :position => 1 },
  { :name => "Category", :position => 2 },
]

taxonomies.each do |taxonomy_attrs|
  create_taxonomy(taxonomy_attrs)
end
