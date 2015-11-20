module Spree
  module Api
    class HotelsController < Spree::Api::BaseController

      # Returns all hotels.
      def index
        items = []
        response = PriceTravel::Api.hotels(params)
        data = JSON.parse(response.body)
        items += (response.code.to_i == 200) ? normalizeItems(data, :price_travel) : [data]

        render json: items, status: response.code
      end

      # Returns hotel details.
      def show
        items = []
        response = PriceTravel::Api.hotels(params)
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
            PriceTravel::Utils.parse_hotels(items)
          else
            items
        end
      end

    end
  end
end