# Taxons to be used as parameters in search sessions.

require Rails.root + "db/common/trip_functions"
include TripFunctions

items = [
    {:name => "BHM: Birmingham-Shuttlesworth"},
    {:name => "DHN: Regional de Dothan"},
    {:name => "HSV: Huntsville"},
    {:name => "MOB: Mobile"},
    {:name => "MGM: Montgomery"}
]

taxonomy = Spree::Taxonomy.where(:name => 'Departure airport').first
items.each do |item|
	create_taxon(taxonomy, item)
end


