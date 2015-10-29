require 'net/http'

module Despegar
  module HTTPService

    PRODUCTION_SERVER = 'https://api.despegar.com/v3'
    DEVELOPMENT_SERVER = ''

    class << self

      def make_request(uri, params={})
        # uri = URI(PRODUCTION_SERVER + uri)
        # uri.query = URI.encode_www_form(params)

        uri = URI('https://api.despegar.com/v3/hotels/availabilities?site=AR&checkin_date=2015-12-01&checkout_date=2015-12-05&destination=982&distribution=2&language=es&accepts=partial')

        http = Net::HTTP.new(uri.host, uri.port, Figaro.env.proxy_address, 3128, Figaro.env.proxy_user, Figaro.env.proxy_password)
        http.use_ssl = uri.scheme == 'https'
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        request['X-ApiKey'] = Figaro.env.despegar_api_key
        http.request(request)
      end

    end
  end
end