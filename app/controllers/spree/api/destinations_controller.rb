module Spree
  module Api
    class DestinationsController < Spree::Api::BaseController

      include Spree::Api::ApiHelpers

      # Returns all destinations.
      def index
        params['service'] ||= 'spree'

        case params['service'].to_sym

          # Get destinations from remote service in 'api.pricetravel.com' provider.
          when :price_travel
            response = PriceTravel::Api.destinations('CU')
            data = JSON.parse(response.body)
            status = response.code.to_i
            items = (status == 200) ? normalizeItems(data['Destinations'], :price_travel) : [data]

          # Get destinations from remote service in 'holiplus.com' provider.
          when :holiplus
            response = Holiplus::Api.destinations()
            data = JSON.parse(response.body)
            status = response.code.to_i
            items = (status == 200) ? normalizeItems(data, :holiplus) : [data]

          # Get destinations from Spree::Taxon model when taxonomy name is 'Destination city'.
          when :spree
            status = 200
            data = Spree::Taxon.ransack(taxonomy_name_eq: 'Destination city').result.where.not(name: 'Destination city')
            items = normalizeItems(data, :spree)

          else
            items = []
        end

        render json: items, status: status
      end

      private

      # Returns items in standard format.
      def normalizeItems(items, service)
        # Get id, name and service
        case service
          when :price_travel
            items.map { |i| {id: i['Id'], name: i['Name'].gsub(/ Area$/, ''), service: 'PRICE_TRAVEL'} }
          when :holiplus
            items.map { |i| {id: i['id'], name: i['name'], service: 'HOLIPLUS'} }
          when :spree
            items.map do |i|
              {
                  id: i.id,
                  name: i.pretty_name.gsub(/^Destination city -> /, '').gsub(/->/, '/'),
                  service: 'SPREE'
              }
            end
          else
            items
        end
      end

    end
  end
end