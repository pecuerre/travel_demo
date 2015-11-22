module Spree
  module Api
    class HotelsController < Spree::Api::BaseController

      before_filter :get_service_destinations_ids, :only => :index

      # Returns all hotels.
      def index
        items = []
        errors = []

        puts '---------------------------------------'
        puts @destinations_ids.inspect

        @destinations_ids.each do |destination|
          service = destination.service_name.to_sym
          params['search-going-to'] = destination.service_item_id

          # Search hotels in service.
          case service
            when :price_travel
              response = PriceTravel::Api.hotels(params)
              status = response.code.to_i
              data = JSON.parse(response.body)
            when :best_day
              # TODO: Revisar api de BestDay para normalizar
              # response = BestDay::Api.hotels(params)
              # status = response.code.to_i
              # data = JSON.parse(response.body)
          end

          if status == 200
            items +=normalizeItems(data, service)
          else
            errors << data
          end
        end

        if !items.empty? || errors.empty?
          render json: items, status: 200
        else
          render json: errors, status: 500
        end
      end

      # Returns hotel details.
      def show
        items = []

        service = params['service'].to_sym
        case service

          # Get hotels from remote service in 'api.pricetravel.com' provider.
          when :price_travel
            response = PriceTravel::Api.hotels(params)
            status = response.code.to_i
            data = JSON.parse(response.body)

          # Get hotels from remote service in 'Best-Day' provider.
          when :best_day
            response = BestDay::Api.hotels(params)
            status = response.code.to_i
            data = JSON.parse(response.body)

        end

        render json: normalizeItems(data, service), status: status
      end

      private

      # Returns items in standard format.
      def normalizeItems(items, service)
        case service

          when :price_travel
            PriceTravel::Utils.parse_hotels(items)

          when :best_day
            # TODO: Revisar api de BestDay para normalizar
            BestDay::Utils.parse_hotels(items)

          else
            items
        end
      end

      # Returns ids in remote service for taxon with id equal to 'search-going-to' parameter and their children.
      def get_service_destinations_ids
        @destinations_ids= []

        taxons = [Spree::Taxon.find(params['search-going-to'].to_i)]

        while !taxons.empty?
          taxon = taxons.pop
          taxons += taxon.children
          @destinations_ids += taxon.foreign_service_ids
        end

      rescue ActiveRecord::RecordNotFound
        render json: {error: 'Destination not found.'}, status: 404
      end

    end
  end
end