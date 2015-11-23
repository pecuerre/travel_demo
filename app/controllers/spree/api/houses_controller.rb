module Spree
  module Api
    class HousesController < Spree::Api::BaseController

      # Returns all hotels.
      def index
        items = []
        response = Holiplus::Api.houses(params)
        data = JSON.parse(response.body)
        status = response.code.to_i
        items += (status == 200) ? normalizeItems(data['data'], :holiplus) : [data]

        render json: items, status: status
      end

      private

      # Returns items in standard format.
      def normalizeItems(items, service)
        case service
          when :holiplus
            Holiplus::Utils.parse_houses(items)
          else
            items
        end
      end

    end
  end
end