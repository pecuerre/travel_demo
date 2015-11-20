module Spree
  module Api
    class CorsController < Spree::Api::BaseController

      def preflight_check
        render nothing: true, content_type: 'text/plain'
      end
    end
  end
end