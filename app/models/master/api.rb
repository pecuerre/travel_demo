module Master
  class Api

    def self.hotels(params)
      custom_log = CustomLogger.new(CUSTOM_LOGFILE)
      custom_log.info params.to_s

      hotels = []
      #~ Rails.cache.dalli.with do |client|
        #~ hotels = client.fetch("hotels #{params['locale'] || I18n.locale} #{params['search-going-to']}, #{params['search-check-in-date']}, #{params['search-check-out-date']}, #{params['search-rooms']}, #{params['search-adults']}, #{params['search-kids']}", 600) do
          best_day = BestDay::Api.new.hotels(params)
          best_day.errors? ? best_day.messages.each{|m| custom_log.warn "Best Day said: #{m}"} : custom_log.info("#{best_day.resources.count} hotels from Best Day")

          #expedia = Expedia::Api.new.hotels(params)
          #expedia.errors? ? expedia.messages.each{|m| custom_log.warn "Expedia said: #{m}"} : custom_log.info("#{expedia.resources.count} hotels from Expedia")

          price_travel = PriceTravel::Api.new.hotels(params)
          price_travel.errors? ? price_travel.messages.each{|m| custom_log.warn "Price Travel said: #{m}"} : custom_log.info("#{price_travel.resources.count} hotels from Price Travel")

          best_day.resources + price_travel.resources
        #~ end
      #~ end

      hotels = Filter.hotels_filter(hotels, params)
      custom_log.info "#{hotels.count} hotels filtered"

      # aqui es donde se mezclan los hotels que coinciden en las OTAs
      hotels.each do |h1|
        if h1.api
          hotels.each do |h2|
            #  en Math.hotels_match se implementa los patrones para determinar cuando 2 hotels son los mismos (siempre estar mejorandolo)
            if h1.api and h2.api and h1.api != h2.api and Match.hotels_match(h1, h2)
              # en Merge.hotels_merge es donde ocurre el proceso de mezcla cuando 2 hotels son los mismos.
              # no es tan simple porque debemos elegir por cada campo de Hotel con cual valor de las 2 OTAs quedarnos
              hotels << Merge.hotels_merge(h1, h2)
              # cuando mezclamos 2 hotels, cremos 1 nuevo, y los 2 originales le seteamos .api = nil para luego eliminarlo
              h1.api = h2.api = nil
            end
          end
        end
      end
      # aqui es donde se eliminan los hotels originales que fueron mezclados
      hotels.select!{|h| h.api}
      custom_log.info "#{hotels.count} hotels after merge"

      # aqui se ordenan los hotels según el criterio seleccionado por el usuario
      hotels = Master::Sort.hotels_sort(hotels, params)
      custom_log.info "hotels sorted by #{params['sort-by']}"
      custom_log.flush

      Kaminari.paginate_array(hotels).page(params[:page])
    end

    def self.flights(params)
      custom_log = CustomLogger.new(CUSTOM_LOGFILE)
      custom_log.info params.to_s

      flights = []

      price_travel = PriceTravel::Api.new.flights(params)
      # price_travel.errors? ? price_travel.messages.each{|m| custom_log.warn "Price Travel said: #{m}"} : custom_log.info("#{price_travel.resources.count} flights from Price Travel")

      flights = price_travel.resources

      flights = Filter.flights_filter(flights, params)

      # flights.each do |h1|
      #   if h1.api
      #     flights.each do |h2|
      #       if h1.api and h2.api and h1.api != h2.api and Match.flights_match(h1, h2)
      #         flights << Merge.flights_merge(h1, h2)
      #         h1.api = h2.api = nil
      #       end
      #     end
      #   end
      # end

      flights.select!{|h| h.api}

      flights = Master::Sort.flights_sort(flights, params)

      Kaminari.paginate_array(flights).page(params[:page])

    end

    def self.cars(params)
      custom_log = CustomLogger.new(CUSTOM_LOGFILE)
      custom_log.info params.to_s
      cars = []
      #~ Rails.cache.dalli.with do |client|
        #~ cars = client.fetch("cars #{params['locale'] || I18n.locale} #{params['search-picking-up']}, #{params['search-dropping-off']}, #{params['search-pick-up-date']}, #{params['search-pick-up-time']}, #{params['search-drop-off-date']}, #{params['search-drop-off-time']}", 600) do
          best_day = BestDay::Api.new.cars(params)
          best_day.errors? ? best_day.messages.each{|m| custom_log.warn "Best Day said: #{m}"} : custom_log.info("#{best_day.resources.count} cars from Best Day")
          cars = best_day.resources
        #~ end
      #~ end

      cars = Filter.cars_filter(cars, params)
      custom_log.info "#{cars.count} cars filtered"

      cars = Master::Sort.cars_sort(cars, params)
      custom_log.info "cars sorted by #{params['sort-by']}"
      custom_log.flush

      Kaminari.paginate_array(cars).page(params[:page])
    end

    def self.packages(params)
      custom_log = CustomLogger.new(CUSTOM_LOGFILE)
      custom_log.info params.to_s
      packages = []
      #~ Rails.cache.dalli.with do |client|
        #~ packages = client.fetch("packages #{params['locale'] || I18n.locale} #{params['search-going-to']}, #{params['search-flying-from']}, #{params['search-arrival-date']}, #{params['search-departure-date']}, #{params['search-rooms']}, #{params['search-adults']}, #{params['search-kids']}", 600) do
          best_day = BestDay::Api.new.packages(params)
          best_day.errors? ? best_day.messages.each{|m| custom_log.warn "Best Day said: #{m}"} : custom_log.info("#{best_day.resources.count} packages from Best Day")
          packages = best_day.resources
        #~ end
      #~ end

      packages = Filter.packages_filter(packages, params)
      custom_log.info "#{packages.count} packages filtered"

      packages = Master::Sort.packages_sort(packages, params)
      custom_log.info "packages sorted by #{params['sort-by']}"
      custom_log.flush

      Kaminari.paginate_array(packages).page(params[:page])
    end

    def self.test(params)
      Despegar::Api.new.test(params)
    end
  end
end
