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
    task :destinations => :environment do
      Spree::Taxon.delete_all
    end

    desc 'Delete all hotels'
    task :hotels => :environment do
      Spree::Product.where(:product_type => Spree::ProductType.find_by_name('hotel')).destroy_all
    end

    desc 'Delete all data (clean de project)'
    task :all => :environment do
      Rake.application['trip:delete:shipping_categories'].invoke
      Rake.application['trip:delete:taxons'].invoke
      Rake.application['trip:delete:taxonomies'].invoke
      Rake.application['trip:delete:hotels'].invoke
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

    desc 'Load all data [shipping categories, taxonomies, destinations, products, etc.]'
    task :all => :environment do
      Rake.application['trip:load:shipping_categories'].invoke
      Rake.application['trip:load:taxonomies'].invoke
      Rake.application['trip:load:destinations'].invoke
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

    desc 'Examples of properties types'
    task :property_types => :environment do
      require Rails.root + "db/examples/property_types"
    end

    desc 'Examples of properties'
    task :properties => :environment do
      require Rails.root + "db/examples/properties"
    end

  	desc 'Examples of hotels'
  	task :hotels do
      Rake.application['trip:delete:hotels'].invoke
      require Rails.root + "db/examples/products_hotels"
  	end

    desc 'Sample for all data'
    task :all => :environment do
      Rake.application['trip:sample:shipping_categories'].invoke
      Rake.application['trip:sample:taxonomies'].invoke
      Rake.application['trip:sample:destinations'].invoke
      Rake.application['trip:sample:property_types'].invoke
      Rake.application['trip:sample:properties'].invoke
      Rake.application['trip:sample:hotels'].invoke
    end
  end
end


