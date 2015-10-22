module Spree
  module Admin
    class StaticEventsController < Spree::Admin::ResourceController

      CATEGORIES_TAXONOMY = Spree::Taxonomy.find_by_name('Categories')
      CATEGORIES_TAXON = Spree::Taxon.find_by_name_and_taxonomy_id('Categories', CATEGORIES_TAXONOMY)
      STATIC_EVENT_TAXON = Spree::Taxon.find_by_name_and_parent_id('StaticEvent', CATEGORIES_TAXON)

      create.after :create_or_update_after
      update.after :create_or_update_after

      protected

      def create_or_update_after
        @object.set_property('link', params['link'])
        @object.taxons = [STATIC_EVENT_TAXON]
      end

      def model_class
        Spree::Product
      end

      def permitted_resource_params
        params.permit(:name, :description, :price, :shipping_category_id)
      end

      def collection
        STATIC_EVENT_TAXON.products.all
      end

      def location_after_save
        admin_static_events_path
      end

      def location_after_destroy
        admin_static_events_path
      end

      def find_resource
        Spree::Product.with_deleted.friendly.find(params[:id])
      end

      def collection_url
        admin_static_events_path
      end

    end
  end
end