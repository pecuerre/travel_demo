require 'ffaker'
#require 'spree_travel_sample'

namespace :trip do

	namespace :load do

  	desc 'Loads trip destinations'
  	task :destinations => :environment do
    	require Rails.root + "db/data/destinations"
  	end

  end

  namespace :example do

  	desc 'Examples of hotels (with properties, and property types)'
  	task :hotels do
  		#Rake.application['spree_travel_sample:load'].invoke('PRODUCT_TYPE=hotels')
  	end
  end
end


