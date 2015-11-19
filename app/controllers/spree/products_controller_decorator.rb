Spree::ProductsController.class_eval do

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @destinations = Spree::Taxon.find_by(:name => "Destinations")

    case @searcher.properties['search-type']
      when 'hotels'
        validate_params_for_hotels
        validate_params_for_filters
        @products = Master::Api.hotels(@searcher.properties)
      when 'flights'
        validate_params_for_flights
        validate_params_for_filters
        @products = Master::Api.flights(@searcher.properties)
      when 'cars'
        validate_params_for_cars
        validate_params_for_filters
        @products = Master::Api.cars(@searcher.properties)
      when 'packages'
        validate_params_for_packages
        validate_params_for_filters
        @products = Master::Api.packages(@searcher.properties)
      when 'houses'
        validate_params_for_packages
        validate_params_for_filters
        @products = Master::Api.houses(@searcher.properties)
      else
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
  end

  def get_ajax_best_day
    @searcher = build_searcher(params.merge(include_images: true))
    
    case @searcher.properties['search-type']
      when 'hotels'
        validate_params_for_hotels
        validate_params_for_filters
        @products = BestDay::Api.new.hotels(@searcher.properties)
      when 'flights'
        validate_params_for_flights
        validate_params_for_filters
        @products = BestDay::Api.new.flights(@searcher.properties)
      when 'cars'
        validate_params_for_cars
        validate_params_for_filters
        @products = BestDay::Api.new.cars(@searcher.properties)
      when 'packages'
        validate_params_for_packages
        validate_params_for_filters
        @products = BestDay::Api.new.packages(@searcher.properties)
      else
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    respond_to do |format|
      format.json {render json: @products}
    end
  end

  def get_ajax_price_travel
    @searcher = build_searcher(params.merge(include_images: true))

    case @searcher.properties['search-type']
      when 'hotels'
        validate_params_for_hotels
        validate_params_for_filters
        @products = PriceTravel::Api.new.hotels(@searcher.properties)
      when 'flights'
        validate_params_for_flights
        validate_params_for_filters
        @products = PriceTravel::Api.new.flights(@searcher.properties)
      when 'cars'
        validate_params_for_cars
        validate_params_for_filters
        @products = PriceTravel::Api.new.cars(@searcher.properties)
      when 'packages'
        validate_params_for_packages
        validate_params_for_filters
        @products = PriceTravel::Api.new.packages(@searcher.properties)
      else
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    respond_to do |format|
      format.json {render json: @products}
    end
  end

  def get_ajax_spree_travel
    @searcher = build_searcher(params.merge(include_images: true))

    case @searcher.properties['search-type']
      when 'houses'
        # validate_params_for_houses
        # validate_params_for_filters
        @products = SpreeTravel::Api.new.houses(params)
      when 'hotels'
        validate_params_for_hotels
        validate_params_for_filters
        @products = SpreeTravel::Api.new.hotels(@searcher.properties)

      when 'flights'
        validate_params_for_flights
        validate_params_for_filters
        @products = SpreeTravel::Api.new.flights(@searcher.properties)
      when 'cars'
        validate_params_for_cars
        validate_params_for_filters
        @products = SpreeTravel::Api.new.cars(@searcher.properties)
      when 'packages'
        validate_params_for_packages
        validate_params_for_filters
        @products = SpreeTravel::Api.new.packages(@searcher.properties)
      else
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    respond_to do |format|
      format.json {render json: @products}
    end
  end

  def get_ajax_aeromexico
    @searcher = build_searcher(params.merge(include_images: true))

    case @searcher.properties['search-type']
      when 'flights'
        validate_params_for_flights
        validate_params_for_filters
        @products = Aeromexico::Api.new.flights(@searcher.properties)
      else
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    respond_to do |format|
      format.json {render json: @products}
    end
  end




  private

  def validate_params_for_houses

  end

  def validate_params_for_hotels
    begin
      return if params['redirected']
      if params['search-going-to'].blank?
        flash[:alert] = "'#{I18n.t(:going_to)}' #{I18n.t('errors.messages.blank')}"
      end
      begin
        @check_in_date = Date.strptime(params['search-check-in-date'], '%m/%d/%Y')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:check_in)}' #{I18n.t(:invalid_date)}"
      end
      begin
        @check_out_date = Date.strptime(params['search-check-out-date'], '%m/%d/%Y')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:check_out)}' #{I18n.t(:invalid_date)}"
      end
      if @check_in_date and @check_out_date and @check_out_date < @check_in_date
        flash[:alert] = I18n.t(:invalid_chronological_order)
      end
      if params['search-rooms'].to_i <= 0
        flash[:alert] = "'#{I18n.t(:rooms)}' #{I18n.t('errors.messages.greater_than', count: 0)}"
      end
      if params['search-adults'].to_i <= 0
        flash[:alert] = "'#{I18n.t(:adults)}' #{I18n.t('errors.messages.greater_than', count: 0)}"
      end
      if params['search-kids'].to_i < 0
        flash[:alert] = "'#{I18n.t(:kids)}' #{I18n.t('errors.messages.greater_than_or_equal_to', count: 0)}"
      end
    rescue StandardError
      flash[:alert] = I18n.t(:wrong_arguments)
    end
    if flash[:alert]
      redirect_to send(params['http-referer'], params.merge({:redirected => true}))
    end
  end

  def validate_params_for_flights
    begin
      return if params['redirected']
      params['search-flight-type'] = 'roundtrip' if params['search-flight-type'] == 'redondo'
      params['search-flight-type'] = 'one way' if params['search-flight-type'] == 'sencillo'
      unless ['roundtrip', 'one way'].include?(params['search-flight-type'])
        flash[:alert] = "'#{I18n.t(:flight_type)}' #{I18n.t('errors.messages.invalid')}"
      end
      if params['search-flying-from'].blank?
        flash[:alert] = "'#{I18n.t(:flying_from)}' #{I18n.t('errors.messages.blank')}"
      end
      if params['search-flying-to'].blank?
        flash[:alert] = "'#{I18n.t(:flying_to)}' #{I18n.t('errors.messages.blank')}"
      end
      begin
        @departing_date = Date.strptime(params['search-departing-date'], '%m/%d/%Y')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:departing_date)}' #{I18n.t(:invalid_date)}"
      end
      begin
        @returning_date = Date.strptime(params['search-returning-date'], '%m/%d/%Y') if params['search-flight-type'] == 'roundtrip'
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:returning_date)}' #{I18n.t(:invalid_date)}"
      end
      if @departing_date and @returning_date and @returning_date < @departing_date
        flash[:alert] = I18n.t(:invalid_chronological_order)
      end
      if params['search-adults'].to_i <= 0
        flash[:alert] = "'#{I18n.t(:adults)}' #{I18n.t('errors.messages.greater_than', count: 0)}"
      end
      if params['search-kids'].to_i < 0
        flash[:alert] = "'#{I18n.t(:kids)}' #{I18n.t('errors.messages.greater_than_or_equal_to', count: 0)}"
      end
    rescue StandardError
      flash[:alert] = I18n.t(:wrong_arguments)
    end
    if flash[:alert]
      redirect_to send(params['http-referer'], params.merge({:redirected => true}))
    end
  end

  def validate_params_for_cars
    begin
      return if params['redirected']
      if params['search-picking-up'].blank?
        flash[:alert] = "'#{I18n.t(:picking_up)}' #{I18n.t('errors.messages.blank')}"
      end
      if params['search-dropping-off'].blank?
        flash[:alert] = "'#{I18n.t(:dropping_off)}' #{I18n.t('errors.messages.blank')}"
      end
      begin
        @pick_up_date = Date.strptime(params['search-pick-up-date'], '%m/%d/%Y')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:pick_up_date)}' #{I18n.t(:invalid_date)}"
      end
      begin
        @drop_off_date = Date.strptime(params['search-drop-off-date'], '%m/%d/%Y')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:drop_off_date)}' #{I18n.t(:invalid_date)}"
      end
      if @pick_up_date and @drop_off_date and @drop_off_date < @pick_up_date
        flash[:alert] = I18n.t(:invalid_chronological_order)
      end
      begin
        Time.strptime(params['search-pick-up-time'], '%l:%M %P')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:pick_up_time)}' #{I18n.t(:invalid_time)}"
      end
      begin
        Time.strptime(params['search-drop-off-time'], '%l:%M %P')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:drop_off_time)}' #{I18n.t(:invalid_time)}"
      end
    rescue StandardError
      flash[:alert] = I18n.t(:wrong_arguments)
    end
    if flash[:alert]
      redirect_to send(params['http-referer'], params.merge({:redirected => true}))
    end
  end

  def validate_params_for_packages
    begin
      return if params['redirected']
      if params['search-going-to'].blank?
        flash[:alert] = "'#{I18n.t(:going_to)}' #{I18n.t('errors.messages.blank')}"
      end
      if params['search-flying-from'].blank?
        flash[:alert] = "'#{I18n.t(:flying_from)}' #{I18n.t('errors.messages.blank')}"
      end
      begin
        @arrival_date = Date.strptime(params['search-arrival-date'], '%m/%d/%Y')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:arrival_date)}' #{I18n.t(:invalid_date)}"
      end
      begin
        @departure_date = Date.strptime(params['search-departure-date'], '%m/%d/%Y')
      rescue ArgumentError
        flash[:alert] = "'#{I18n.t(:departure_date)}' #{I18n.t(:invalid_date)}"
      end
      if @arrival_date and @departure_date and @departure_date < @arrival_date
        flash[:alert] = I18n.t(:invalid_chronological_order)
      end
      if params['search-rooms'].to_i <= 0
        flash[:alert] = "'#{I18n.t(:rooms)}' #{I18n.t('errors.messages.greater_than', count: 0)}"
      end
      if params['search-adults'].to_i <= 0
        flash[:alert] = "'#{I18n.t(:adults)}' #{I18n.t('errors.messages.greater_than', count: 0)}"
      end
      if params['search-kids'].to_i < 0
        flash[:alert] = "'#{I18n.t(:kids)}' #{I18n.t('errors.messages.greater_than_or_equal_to', count: 0)}"
      end
    rescue StandardError
      flash[:alert] = I18n.t(:wrong_arguments)
    end
    if flash[:alert]
      redirect_to send(params['http-referer'], params.merge({:redirected => true}))
    end
  end

  def validate_params_for_filters
    begin
      return if params['redirected']
      if not params['filter-min-price'].blank? and params['filter-min-price'].to_f <= 0
        flash[:alert] = "'Min #{I18n.t(:Price)}' #{I18n.t('errors.messages.greater_than', count: 0)}"
      end
      if not params['filter-max-price'].blank? and params['filter-max-price'].to_f <= 0
        flash[:alert] = "'Max #{I18n.t(:Price)}' #{I18n.t('errors.messages.greater_than', count: 0)}"
      end
      if not params['filter-min-price'].blank? and not params['filter-max-price'].blank? and params['filter-max-price'].to_f < params['filter-min-price'].to_f
        flash[:alert] = "'Max #{I18n.t(:Price)}' #{I18n.t('errors.messages.greater_than', count: "'Min #{I18n.t(:Price)}'")}"
      end
    rescue StandardError
      flash[:alert] = I18n.t(:wrong_arguments)
    end
#    if flash[:alert]
#      redirect_to send(params['http-referer'], params.merge({:redirected => true}))
#    end
  end

end
