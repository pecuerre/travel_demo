module Spree
  module Admin
    class StaticImagesController < Spree::Admin::ResourceController

      def model_class
        StaticImage
      end

    end
  end
end