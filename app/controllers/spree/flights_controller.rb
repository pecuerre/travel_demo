require 'travel_demo/flight'
require 'travel_demo/booking_order'

module Spree

  class FlightsController < Spree::StoreController

    respond_to :html
    before_action :get_flights, only: [:index, :list, :grid, :block, :detail, :booking, :thanks_you]

    def index
      @view = params[:view]
    end

    def detail
    end

    def booking
    end

    def thanks_you
    end

    private
    def get_flights
      # @flights= ::Sample::Flight.sample
      @airlines=::Sample::Flight.airlines
      @stops=::Sample::Flight.stops
      @flight_types=::Sample::Flight.flight_types
      @features=::Sample::Flight.features
      @booking=::Sample::Booking_Order.sample
      @products = @flights

      api = SpreeTravel::Api.new
      @flights = api.flights(params)
    end
  end
end