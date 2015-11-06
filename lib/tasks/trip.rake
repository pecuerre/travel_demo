require 'ffaker'
#require 'spree_travel_sample'

namespace :trip do

  #############################################################################
  ### Delete tasks
  #############################################################################
  namespace :delete do

    desc 'Delete shipping categories'
    task :shipping_categories => :environment do
      Spree::ShippingCategory.delete_all
    end

    desc 'Delete taxonomies'
    task :taxonomies => :environment do
      Spree::Taxonomy.delete_all
    end

    desc 'Delete trip destinations'
    task :destinations => :environment do
      taxonomy = Spree::Taxonomy.where(:name => 'Destination').first
      Spree::Taxon.where(:taxonomy => taxonomy).delete_all
    end

    desc 'Delete all taxons'
    task :taxons => :environment do
      Spree::Taxon.delete_all
    end

    desc 'Delete all hotels'
    task :hotels => :environment do
      Spree::Product.where(:product_type => Spree::ProductType.find_by_name('hotel')).destroy_all
    end

    desc 'Delete all rates'
    task :rates => :environment do
      Spree::Rate.destroy_all
    end

    desc 'Delete all fligths'
    task :flights => :environment do
      Spree::Product.where(:product_type => Spree::ProductType.find_by_name('flight')).destroy_all
    end

    desc 'Delete all data (clean de project)'
    task :all => :environment do
      Rake.application['trip:delete:shipping_categories'].invoke
      Rake.application['trip:delete:destinations'].invoke
      Rake.application['trip:delete:taxons'].invoke
      Rake.application['trip:delete:taxonomies'].invoke
      Rake.application['trip:delete:hotels'].invoke
      Rake.application['trip:delete:flights'].invoke
      Rake.application['trip:delete:rates'].invoke
    end
  end

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

    namespace :property_types do
      desc 'Properties types for flights'
      task :flights => :environment do
        require Rails.root + "db/data/property_types_flights"
      end
    end

    namespace :properties do
      desc 'Properties for flights'
      task :flights => :environment do
        require Rails.root + "db/data/properties_flights"
      end
    end

    namespace :products do
      desc 'Product for flights'
      task :flights do
        Rake.application['trip:delete:flights'].invoke
        require Rails.root + "db/data/products_flights"
      end
    end

    namespace :rates do
      desc 'Rates for flights'
      task :flights do
        #require Rails.root + "db/data/rates_flights"
      end
    end

    desc 'Load all data [shipping categories, taxonomies, destinations, products, etc.]'
    task :all => :environment do
      Rake.application['trip:load:shipping_categories'].invoke
      Rake.application['trip:load:taxonomies'].invoke
      Rake.application['trip:load:destinations'].invoke
      Rake.application['trip:load:property_types:flights'].invoke
      Rake.application['trip:load:properties:flights'].invoke
      Rake.application['trip:load:products:flights'].invoke
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

    desc 'Examples of taxonomies'
    task :taxonomies => :environment do
      Rake.application['trip:load:taxonomies'].invoke
    end

    desc 'Examples of destinations'
    task :destinations => :environment do
      Rake.application['trip:load:destinations'].invoke
    end

    namespace :property_types do 
      desc 'Examples of properties types for hotels'
      task :hotels => :environment do
        require Rails.root + "db/examples/property_types_hotels"
      end
    end

    namespace :properties do
      desc 'Examples of properties for hotels'
      task :hotels => :environment do
        require Rails.root + "db/examples/properties_hotels"
      end
    end

    namespace :products do
    	desc 'Examples of product for hotels'
    	task :hotels do
        Rake.application['trip:delete:hotels'].invoke
        require Rails.root + "db/examples/products_hotels"
    	end
    end

    namespace :rates do
      desc 'Examples of rates for hotels'
      task :hotels do
        require Rails.root + "db/examples/rates_hotels"
      end
    end

    desc 'Sample for all data'
    task :all => :environment do
      Rake.application['trip:sample:shipping_categories'].invoke
      Rake.application['trip:sample:taxonomies'].invoke
      Rake.application['trip:sample:destinations'].invoke
      Rake.application['trip:sample:property_types:hotels'].invoke
      Rake.application['trip:sample:properties:hotels'].invoke
      Rake.application['trip:sample:products:hotels'].invoke
      Rake.application['trip:sample:rates:hotels'].invoke
    end
  end
end


