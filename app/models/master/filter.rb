module Master
  class Filter

    def self.hotels_filter(hotels, params)
      if params['filter-stars'] and not params['filter-stars'] == ''
        hotels.select!{|h| params['filter-stars'].include?(h.stars.to_s)}
      end
      if params['filter-min-price'] and not params['filter-min-price'] == ''
        hotels.select!{|h| h.prices.values.max >= params['filter-min-price'].to_f}
      end
      if params['filter-max-price'] and not params['filter-max-price'] == ''
        hotels.select!{|h| h.prices.values.min <= params['filter-max-price'].to_f}
      end
      if params['filter-hotel-name'] and not params['filter-hotel-name'] == ''
        hotels.select!{|h| h.name.downcase.index(params['filter-hotel-name'].downcase)}
      end
      hotels
    end

    def self.flights_filter(flights, params)
      if params['filter-min-price'] and not params['filter-min-price'] == ''
        flights.select!{|f| f.prices.values.max >= params['filter-min-price'].to_f}
      end
      if params['filter-max-price'] and not params['filter-max-price'] == ''
        flights.select!{|f| f.prices.values.min <= params['filter-max-price'].to_f}
      end
      if params['filter-airline'] and not params['filter-airline'] == ''
        flights.select!{|f| f.airline.downcase == params['filter-airline'].downcase}
      end
      flights.select!{|f| f.departure_flights.count > 0}
      flights
    end

    def self.cars_filter(cars, params)
      if params['filter-min-price'] and not params['filter-min-price'] == ''
        cars.select!{|c| c.prices.values.max >= params['filter-min-price'].to_f}
      end
      if params['filter-max-price'] and not params['filter-max-price'] == ''
        cars.select!{|c| c.prices.values.min <= params['filter-max-price'].to_f}
      end
      if params['filter-brand'] and not params['filter-brand'] == ''
        cars.select!{|c| c.name.downcase.index(params['filter-brand'].downcase)}
      end
      cars
    end
    
    def self.packages_filter(packages, params)
      if params['filter-stars'] and not params['filter-stars'] == ''
        packages.select!{|p| params['filter-stars'].include?(p.hotel.stars.to_s)}
      end
      if params['filter-min-price'] and not params['filter-min-price'] == ''
        packages.select!{|p| p.prices.values.max >= params['filter-min-price'].to_f}
      end
      if params['filter-max-price'] and not params['filter-max-price'] == ''
        packages.select!{|p| p.prices.values.min <= params['filter-max-price'].to_f}
      end
      if params['filter-hotel-name'] and not params['filter-hotel-name'] == ''
        packages.select!{|p| p.hotel.name.downcase.index(params['filter-hotel-name'].downcase)}
      end
      packages
    end

  end
end