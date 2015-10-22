module Spree
  module Admin
    class AttractionsController < Spree::Admin::ResourceController

      CATEGORIES_TAXONOMY = Spree::Taxonomy.find_by_name('Categories')
      DESTINATIONS_TAXONOMY = Spree::Taxonomy.find_by_name('Destinations')
      CATEGORIES_TAXON = Spree::Taxon.find_by_name_and_taxonomy_id('Categories', CATEGORIES_TAXONOMY)
      ATTRACTIONS_TAXON = Spree::Taxon.find_by_name_and_parent_id('Attractions', CATEGORIES_TAXON)

      create.after :create_or_update_after
      update.after :create_or_update_after

      protected

      def create_or_update_after
        @object.set_property('spanish_description', params['spanish_description'])

        destination_taxon = Spree::Taxon.find_or_create_by(name: destination.name, parent_id: DESTINATIONS_TAXONOMY.root.id, taxonomy_id: DESTINATIONS_TAXONOMY.id)
        attraction_taxon = Spree::Taxon.find_or_create_by(name: @object.name, parent_id: destination_taxon.id, taxonomy_id: DESTINATIONS_TAXONOMY.id)
        @object.taxons = [ATTRACTIONS_TAXON, attraction_taxon]

        @object.available_on = Date.today
        @object.save
      end

      def model_class
        Spree::Product
      end

      def permitted_resource_params
        params.permit(:name, :description, :price, :shipping_category_id)
      end

      def collection
        @destination = destination
        destination_taxon = destination.taxons.find{|t|t.taxonomy==DESTINATIONS_TAXONOMY and t.depth==1}
        attractions = []
        if destination_taxon
          attraction_taxons = destination_taxon.children

          attraction_taxons.each do |attraction_taxon|
            attraction_taxon.products.each do |attraction|
              attractions << attraction unless attractions.include?(attraction)
            end
          end
        end
        attractions
      end

      def location_after_save
        admin_destination_attractions_path(destination)
      end

      def location_after_destroy
        admin_destination_attractions_path(destination)
      end

      def find_resource
        Spree::Product.with_deleted.friendly.find(params[:id])
      end

      def destination
        Spree::Product.with_deleted.friendly.find(params[:destination_id])
      end

      def collection_url
        admin_destination_attractions_path(destination)
      end

      def edit_object_url(object, options = {})
        edit_admin_destination_attraction_path(destination, object, options)
      end

      def object_url(object = nil, options = {})
        target = object ? object : @object
        admin_destination_attraction_path(destination, target, options)
      end

    end
  end
end