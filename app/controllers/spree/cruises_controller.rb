require 'travel_demo/cruise'
require 'travel_demo/booking_order'

module Spree
  class CruisesController < Spree::StoreController
    helper 'spree/products'
    respond_to :html
    before_action :get_cruises, only: [:list, :grid, :block, :detail, :booking, :thanks_you]

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    def list
    end

    def grid
    end

    def block
    end

    def detail
    end

    def booking
    end

    def thanks_you
    end

    private
    def get_cruises
      @cruises= ::Sample::Cruise.sample
      @booking=::Sample::Booking_Order.sample
    end

  end
end