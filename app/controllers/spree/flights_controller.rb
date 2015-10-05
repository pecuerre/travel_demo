module Spree
  class FlightsController < Spree::StoreController

    respond_to :html
    before_action :get_flights, only: [:list, :grid, :block]
    def index
     list
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
    def get_flights
      @flights= Flight::sample

    end


    class Flight

      class << self

        def generateFlight

          flight = OpenStruct.new
          flight.name = Faker::Address.country + ' - '+ Faker::Address.country
          flight.takeoff=Faker::Time.month.to_s
          flight
        end

        def sample
          @flight = @@_flights ||=
              begin
                flight= []
                sample_size=10
                sample_size.times do
                  flight << generateFlight
                end

                flight
              end
        end

      end
    end

  end
end