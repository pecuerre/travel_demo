Spree::Core::Search::Base.class_eval do

  def prepare(params)
    @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Taxon.find(params[:taxon])
    @properties[:keywords] = params[:keywords]
    @properties[:search] = params[:search]
    @properties[:include_images] = params[:include_images]

    per_page = params[:per_page].to_i
    @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
    @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i

    @properties['search-type'] = params['search-type']
    @properties['sort-by'] = params['sort-by']
    case @properties['search-type']
      when 'hotels'
        @properties['search-going-to'] = params['search-going-to']
        @properties['search-check-in-date'] = params['search-check-in-date']
        @properties['search-check-out-date'] = params['search-check-out-date']
        @properties['search-rooms'] = params['search-rooms']
        @properties['search-adults'] = params['search-adults']
        @properties['search-kids'] = params['search-kids']
        @properties['filter-stars'] = params['filter-stars']
        @properties['filter-min-price'] = params['filter-min-price']
        @properties['filter-max-price'] = params['filter-max-price']
        @properties['filter-hotel-name'] = params['filter-hotel-name']
      when 'flights'
        @properties['search-type'] = params['search-type']
        @properties['search-flight-type'] = params['search-flight-type']
        @properties['search-flying-from'] = params['search-flying-from']
        @properties['search-flying-to'] = params['search-flying-to']
        @properties['search-departing-date'] = params['search-departing-date']
        @properties['search-returning-date'] = params['search-returning-date']
        @properties['search-adults'] = params['search-adults']
        @properties['search-kids'] = params['search-kids']
        @properties['filter-min-price'] = params['filter-min-price']
        @properties['filter-max-price'] = params['filter-max-price']
        @properties['filter-airline'] = params['filter-airline']
      when 'cars'
        @properties['search-picking-up'] = params['search-picking-up']
        @properties['search-dropping-off'] = params['search-dropping-off']
        @properties['search-pick-up-date'] = params['search-pick-up-date']
        @properties['search-pick-up-time'] = params['search-pick-up-time']
        @properties['search-drop-off-date'] = params['search-drop-off-date']
        @properties['search-drop-off-time'] = params['search-drop-off-time']
        @properties['filter-min-price'] = params['filter-min-price']
        @properties['filter-max-price'] = params['filter-max-price']
        @properties['filter-brand'] = params['filter-brand']
      when 'packages'
        @properties['search-going-to'] = params['search-going-to']
        @properties['search-flying-from'] = params['search-flying-from']
        @properties['search-arrival-date'] = params['search-arrival-date']
        @properties['search-departure-date'] = params['search-departure-date']
        @properties['search-rooms'] = params['search-rooms']
        @properties['search-adults'] = params['search-adults']
        @properties['search-kids'] = params['search-kids']
        @properties['filter-stars'] = params['filter-stars']
        @properties['filter-min-price'] = params['filter-min-price']
        @properties['filter-max-price'] = params['filter-max-price']
        @properties['filter-hotel-name'] = params['filter-hotel-name']
    end
  end
end