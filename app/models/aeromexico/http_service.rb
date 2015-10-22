require 'net/http'
require 'oauth2'

module Aeromexico
  module HTTPService

    DEVELOPMENT_SERVER = 'https://api.test.sabre.com'
    PRODUCTION_SERVER = 'https://api.sabre.com'

    class << self

      def make_request(uri, params={})
        # uri = URI( + uri)
        # uri.query = URI.encode_www_form(params)
        #
        # http = Net::HTTP.new(uri.host, uri.port, Figaro.env.proxy_address, Figaro.env.proxy_port, Figaro.env.proxy_user, Figaro.env.proxy_password)
        # http.set_debug_output($stdout)
        # request = Net::HTTP::Get.new uri.request_uri
        # http.request(request)

        # client = OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], site: DEVELOPMENT_SERVER, token_url: '/v1/auth/token')
        client = OAuth2::Client.new(ENV['AEROMEXICO_CLIENT_ID'], ENV['AEROMEXICO_CLIENT_SECRET'], site: 'https://api.test.sabre.com', token_url: '/v1/auth/token')

        token = client.client_credentials.get_token
        token.get uri, params: params




      end



    end
  end
end