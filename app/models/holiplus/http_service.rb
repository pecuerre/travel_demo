require 'net/http'

module Holiplus
  module HTTPService

    PRODUCTION_SERVER = 'https://holiplus.com/api/v1'

    class << self

      def make_request(uri, params={}, base_url=false)
        locale = (params['locale'].to_s.empty? ? I18n.locale : params['locale']).to_s
        base_url ||= PRODUCTION_SERVER
        uri = URI("#{base_url}/#{locale}/#{uri}")
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port, Figaro.env.proxy_address, Figaro.env.proxy_port, Figaro.env.proxy_user, Figaro.env.proxy_password)
        http.use_ssl = uri.scheme == 'https'
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        request.content_type = 'text/json'
        http.request(request)
      end

    end
  end
end