require 'travel_demo/tours'
require 'travel_demo/booking_order'

module Spree
  class ToursController < Spree::StoreController
    helper 'spree/products'
    respond_to :html
    before_action :get_tours, only: [:index, :detail, :booking, :thanks_you]

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    def detail
    end

    def booking
    end

    def thanks_you
    end

    private
    def get_tours
      @cruises = ::Sample::Cruise.sample
      @booking = ::Sample::Booking_Order.sample
      @products = @tours
    end

  end
end