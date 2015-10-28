module Spree
  module Admin
    class ApiDestinationsController < Spree::Admin::ResourceController

      def model_class
        Destination
      end

      def collection_url
        admin_api_destinations_url
      end

      def object_name
        'destination'
      end

      def new_object_url(options = {})
        new_admin_api_destination_url(options)
      end

      def edit_object_url(object, options = {})
        edit_admin_api_destination_url(object, options)
      end

      def object_url(object = nil, options = {})
        target = object ? object : @object
        admin_api_destination_url(target, options)
      end

    end
  end
end