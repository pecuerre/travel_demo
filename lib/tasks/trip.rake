require 'ffaker'
#require 'spree_travel_sample'

namespace :trip do

	namespace :load do

  	desc 'Loads trip destinations'
  	task :destinations => :environment do
    	require Rails.root + "db/data/destinations"
  	end

  end

  namespace :sample do

  	desc 'Examples of hotels (with properties, and property types, etc.)'
  	task :hotels do
  		Rake.application['spree_travel_sample:load:hotels']
  	end

    desc 'Examples of packages (with properties, and property types, etc.)'
    task :packages do
      Rake.application['spree_travel_sample:load:packages']
    end

    desc 'Full sample of all models'
    task :all do
      Rake.application['spree_travel_sample:load:all']
    end
  end
end


