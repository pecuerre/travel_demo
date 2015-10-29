require 'net/http'

module PriceTravel
  module HTTPService

    PRODUCTION_SERVER = 'https://api.pricetravel.com/v1'
    DEVELOPMENT_SERVER = 'http://test-api.pricetravel.com.mx'
                       # https://test-api.pricetravel.com.mx/

    class << self

      def make_request(uri, params={})
        uri = URI(PRODUCTION_SERVER + uri)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port, Figaro.env.proxy_address, Figaro.env.proxy_port, Figaro.env.proxy_user, Figaro.env.proxy_password)
        http.use_ssl = uri.scheme == 'https'
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        request.content_type = 'text/json'
        request.basic_auth(Figaro.env.price_travel_user, Figaro.env.price_travel_password)
        http.request(request)
      end

    end
  end
end