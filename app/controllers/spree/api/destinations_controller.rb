module Spree
  module Api
    class DestinationsController < Spree::Api::BaseController

      # Returns all destinations to Cuba.
      def index
        items = []
        response = PriceTravel::Api.destinations('CU')
        data = JSON.parse(response.body)
        items += (response.code.to_i == 200) ? normalizeItems(data['Destinations'], :price_travel) : [data]

        render json: items, status: response.code
      end

      # Returns destination details to Cuba.
      def show
        items = []
        response = PriceTravel::Api.destinations('CU', params[:id])
        data = JSON.parse(response.body)
        items += (response.code.to_i == 200) ? normalizeItems(data, :price_travel) : [data]

        render json: items, status: response.code
      end

      private

      # Returns items in standard format.
      def normalizeItems(items, service)
        # TODO: Normalizar los items a un formato estandar.
        case service
          when :price_travel
            # Get id and name
            items.map { |i| {id: i['Id'], name: i['Name'].gsub(/ Area$/, '')} }
          else
            items
        end
      end

    end
  end
end