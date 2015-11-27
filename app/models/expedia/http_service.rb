require 'faraday'
require 'expedia/http_service/response'
require 'expedia/errors'
# include Expedia

module Expedia
  module HTTPService

    API_SERVER = 'api.eancdn.com'
    RESERVATION_SERVER = 'book.api.ean.com'
    DEVELOPMENT_SERVER = 'dev.api.ean.com'

    CID = 55505 # your cid once you go live.
    API_KEY = Figaro.env.expedia_api_key
    SHARED_SECRET = Figaro.env.expedia_shared_secret
    LOCALE = 'en_US' # For Example 'de_DE'. Default is 'en_US'
    CURRENCY_CODE = 'USD' # For Example 'EUR'. Default is 'USD'
    MINOR_REV = 26 # between 4-26 as of July 2014. Default is 4. 26 being latest

    class << self


      # The address of the appropriate Expedia server.
      #
      # @param options various flags to indicate which server to use.
      # @option options :reservation_api use the RESERVATION API instead of the REGULAR API
      # @option options :use_ssl force https, even if not needed
      #
      # @return a complete server address with protocol
      def server(options = {})
        if CID.to_i == 55505 && !options[:reservation_api]
          server = DEVELOPMENT_SERVER
        else
          server = options[:reservation_api] ? RESERVATION_SERVER : API_SERVER
        end
        "#{options[:use_ssl] ? "https" : "http"}://#{server}"
      end

      # Makes a request directly to Expedia.
      # @note You'll rarely need to call this method directly.
      #
      # @see Expedia::API#api
      #
      # @param path the server path for this request
      # @param args (see Expedia::API#api)
      # @param verb the HTTP method to use.
      # @param options same options passed to server method.
      #
      # @raise an appropriate connection error if unable to make the request to Expedia
      #
      # @return [Expedia::HTTPService::Response] on success. A response object representing the results from Expedia
      # @return [Expedia::APIError] on Error.
      def make_request(path, args, verb, options = {})
        args = common_parameters.merge(args)
        # figure out our options for this request
        request_options = {:params => (verb == :get ? args : {})}

        ## set up our Faraday connection
        #conn = Faraday.new(server(options), request_options)
        #response = conn.send(verb, path, (verb == :post ? args : {}))

        uri = URI(server(options)+path)
        uri.query = URI.encode_www_form(args)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.set_debug_output($stdout)
        request = Net::HTTP::Get.new uri.request_uri
        request.content_type = 'text/json'
        response = http.request(request)
        response = HTTPService::Response.new(response.code, response.body, response)

        # Log URL and params information
        Expedia::Utils.debug "\nExpedia [#{verb.upcase}] - #{server(options) + path} params: #{args.inspect} : #{response.status}\n"

        # If there is an exception make a [Expedia::APIError] object to return
        if response.exception?
          body = response.body
          status = response.status
          if body['HotelListResponse'] and body['HotelListResponse']['LocationInfos'] and body['HotelListResponse']['LocationInfos']['LocationInfo'].count > 1
            Expedia::Errors::MultipleDestinationsFound.new(status, body, response.body['HotelListResponse']['LocationInfos']['LocationInfo'])
          else
            Expedia::Errors::APIError.new(status, body)
          end
        else
          response
        end
      end

      # Creates a Signature for Expedia using MD5 Checksum Auth.
      # Shared and Api keys are required for Signature along with the current utc time.
      def signature
        if CID && API_KEY && SHARED_SECRET
          Digest::MD5.hexdigest(API_KEY + SHARED_SECRET + Time.now.utc.to_i.to_s)
        else
          raise Expedia::AuthCredentialsError, "cid, api_key and shared_secret are required for Expedia Authentication."
        end
      end

      # Common Parameters required for every Call to Expedia Server.
      # @return [Hash] of all common parameters.
      def common_parameters
        { :cid => CID, :sig => signature, :apiKey => API_KEY, :minorRev => MINOR_REV,
          :_type => 'json', :locale => LOCALE, :currencyCode => CURRENCY_CODE }
      end

    end

  end
end
