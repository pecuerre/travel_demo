module Spree
  module Admin
    class DestinationsController < Spree::Admin::ResourceController

      CATEGORIES_TAXONOMY = Spree::Taxonomy.find_by_name('Categories')
      DESTINATIONS_TAXONOMY = Spree::Taxonomy.find_by_name('Destinations')
      CATEGORIES_TAXON = Spree::Taxon.find_by_name_and_taxonomy_id('Categories', CATEGORIES_TAXONOMY)
      DESTINATIONS_TAXON = Spree::Taxon.find_by_name_and_parent_id('Destinations', CATEGORIES_TAXON)

      create.after :create_or_update_after
      update.after :create_or_update_after
      destroy.before :destroy_attractions

      protected

      def create_or_update_after
        @object.set_property('price_travel_id', params['price_travel_id'])
        @object.set_property('best_day_id', params['best_day_id'])
        @object.set_property('spanish_description', params['spanish_description'])

        destination_taxon = Spree::Taxon.find_or_create_by(name: @object.name, parent_id: DESTINATIONS_TAXONOMY.root.id, taxonomy_id: DESTINATIONS_TAXONOMY.id)
        @object.taxons = [DESTINATIONS_TAXON, destination_taxon]

        @object.available_on = Date.today
        @object.save
      end

      def destroy_attractions
        destination_taxon = @object.taxons.find{|t|t.taxonomy==DESTINATIONS_TAXONOMY and t.depth==1}
        attraction_taxons = destination_taxon.children
        attraction_taxons.each do |attraction_taxon|
          attraction_taxon.products.each{|product| product.delete}
        end
        attraction_taxons.each{|taxon|taxon.delete}
        destination_taxon.delete
      end

      def model_class
        Spree::Product
      end

      def permitted_resource_params
        params.permit(:name, :description, :price, :shipping_category_id)
      end

      def collection
        DESTINATIONS_TAXON.products.all
      end

      def location_after_save
        admin_destinations_path
      end

      def location_after_destroy
        admin_destinations_path
      end

      def find_resource
        Spree::Product.with_deleted.friendly.find(params[:id])
      end

      def collection_url
        admin_destinations_path
      end

    end
  end
end