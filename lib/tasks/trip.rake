require 'ffaker'
#require 'spree_travel_sample'

namespace :trip do

  #############################################################################
  ### Load tasks
  #############################################################################
	namespace :load do

    desc 'Load shipping categories'
    task :shipping_categories => :environment do
      require Rails.root + "db/data/shipping_categories"
    end

    desc 'Load taxonomies'
    task :taxonomies => :environment do
      require Rails.root + "db/data/taxonomies"
    end

    desc 'Loads trip destinations'
    task :destinations => :environment do
      require Rails.root + "db/data/destinations"
    end

    desc 'Load all the data'
    task :all => :environment do
      Rake.application['trip:load:shipping_categories'].invoke
      Rake.application['trip:load:taxonomies'].invoke
    end
  end

  #############################################################################
  ### Sample Tasks
  #############################################################################
  namespace :sample do

    desc 'Examples of shipping categories'
    task :shipping_categories => :environment do
      Rake.application['trip:load:shipping_categories'].invoke
    end

  	desc 'Examples of hotels'
  	task :hotels do
  		Rake.application['spree_travel_sample:load:hotels']
  	end

    desc 'Examples of packages (with properties, and property types, etc.)'
    task :packages do
      Rake.application['spree_travel_sample:load:packages']
    end

  #   desc 'Full sample of all models'
  #   task :all do
  #     Rake.application['spree_travel_sample:load:all']
  #   end
  end
end


