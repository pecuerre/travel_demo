require 'net/http'

module BestDay
  module HTTPService

    # PRODUCTION_SERVER = 'http://xml.e-tsw.com/AffiliateService/V1.0/AffiliateService.svc/restful'
    # PRODUCTION_SERVER = 'http://testxml.e-tsw.com/AffiliateService/V1.0/AffiliateService.svc/restful'
    PRODUCTION_SERVER = 'http://testxml.e-tsw.com/AffiliateService/AffiliateService.svc/restful'

    class << self

      def make_request(uri, params={})
        uri = URI(PRODUCTION_SERVER + uri)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port, Figaro.env.proxy_address, Figaro.env.proxy_port, Figaro.env.proxy_user, Figaro.env.proxy_password)
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        http.request(request)
      end

      def cities(uri, params={})
        uri = URI(PRODUCTION_SERVER + uri)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port, Figaro.env.proxy_address, Figaro.env.proxy_port, Figaro.env.proxy_user, Figaro.env.proxy_password)
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        http.request(request)
      end

    end
  end
end


#"GET /AffiliateService/V1.0/AffiliateService.svc/restful/GetQuoteFlights?a=MOREMEX&c=US&sd=20150515&ed=20150520&at=2&ki=0&d=&dd=MIA&da=CUN&l=ING&cb=&tv=R&ty=fl&hash=&ip=200.55.139.220