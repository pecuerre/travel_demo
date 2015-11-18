# Taxons to be used as parameters in search sessions.

require Rails.root + "db/common/trip_functions"
include TripFunctions

items = [
  {:name => "HAV: José Martí, La Habana"},
  {:name => "SCU: Antonio Maceo, Santiago de Cuba"},
  {:name => "VRA: Juan Gualberto Gómez, Varadero"},
  {:name => "HOG: Frank País, Holguín"},
  {:name => "CCC: Jardines del Rey, Cayo Coco"},
  {:name => "AVI: Máximo Gómez, Ciego de Avila"},
  {:name => "CMW: Ignacio Agramonte, Camaguey"},
  {:name => "CYO: Vilo Acuña, Cayo Largo del Sur"},
  {:name => "SNU: Abel Santamaría, Santa Clara"},
  {:name => "CFG: Jaime González, Cienfuegos"},
  {:name => "GAO: Mariana Grajales, Guantánamo"},
  {:name => "MZO: Sierra Maestra, Manzanillo"}
]

taxonomy = Spree::Taxonomy.where(:name => 'Arrival airport').first
items.each do |item|
	create_taxon(taxonomy, item)
end


