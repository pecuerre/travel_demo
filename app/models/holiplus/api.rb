module Holiplus
  module Api
    class << self

      # Returns all destinations or one destination details.
      def destinations(query='')
        Holiplus::HTTPService.make_request('destinations.json', {s: query}, 'https://holiplus.com')
      rescue StandardError => e
        respondError(e.to_s, 500)
      end

      def houses(params)
        # Prepare service url and parameters structure.
        if (params[:id])
          service = "house/#{params[:id]}/show.json"
          params = Holiplus::Utils.prepare_for_house(params)
        else
          # Validated filter parameters.
          if params['search-going-to'].to_i == 0
            raise ArgumentError, 'Destination not found.'
          elsif params['search-check-in-date'].to_s == '' or params['search-check-out-date'].to_s == ''
            raise ArgumentError, 'There is not enough information to verify availability of hotels.'
          end

          service = "houses/request.json"
          params = Holiplus::Utils.prepare_for_houses(params)
        end

        # Send request to holiplus.com
        response = Holiplus::HTTPService.make_request(service, params)

        # Check error response. HoliPlus return error response as string with this format: ": message".
        if error = response.body.match(/^": (.*)"$/)
          respondError(error[1], 500)
        else
          response
        end

      rescue ArgumentError => e
        respondError(e.to_s, 404)
      rescue StandardError => e
        respondError(e.to_s, 500)
      end

      # Returns object similar to 'api.pricetravel.com' response,
      # with {body: {error: '...'}, code: ### } structure.
      def respondError(msg, code)
        h = {:body => {error: msg}.to_json, :code => code}
        Struct.new(*h.keys).new(*h.values)
      end

    end
  end
end
