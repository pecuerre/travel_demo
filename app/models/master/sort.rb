module Master
  class Sort

    def self.hotels_sort(hotels, params)
      params['sort-by'] = 'price' if params['sort-by'].blank?
      case params['sort-by']
        when 'price'
          hotels.sort_by!{|h| h.prices.values.min}
        when 'name'
          hotels.sort_by!{|h| h.name}
        when 'stars'
          hotels.sort_by!{|h| -h.stars}
      end
      hotels
    end

    def self.flights_sort(flights, params)
      params['sort-by'] = 'price' if params['sort-by'].blank?
      case params['sort-by']
        when 'price'
          flights.sort_by!{|f| f.prices.values.min}
        when 'airline'
          flights.sort_by!{|f| f.airline}
      end
      flights
    end

    def self.cars_sort(cars, params)
      params['sort-by'] = 'price' if params['sort-by'].blank?
      case params['sort-by']
        when 'price'
          cars.sort_by!{|c| c.prices.values.min}
      end
      cars
    end

    def self.packages_sort(packages, params)
      params['sort-by'] = 'price' if params['sort-by'].blank?
      case params['sort-by']
        when 'price'
          packages.sort_by!{|p| p.hotel.prices.values.min}
        when 'name'
          packages.sort_by!{|p| p.hotel.name}
        when 'stars'
          packages.sort_by!{|p| -p.hotel.stars}
        when 'airline'
          packages.sort_by!{|p| p.flight.airline}
      end
      packages
    end

  end
end