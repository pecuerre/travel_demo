require 'travel_demo/car'
require 'travel_demo/booking_order'

module Spree
  class CarsController < Spree::StoreController
    helper 'spree/products'
    respond_to :html
    before_action :get_cars, only: [:list, :grid, :block, :detail, :booking, :thanks_you]

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
    def get_cars
      @cars= ::Sample::Car.sample
      @cars_types=::Sample::Car.car_types
      @booking=::Sample::Booking_Order.sample
    end
  end
end