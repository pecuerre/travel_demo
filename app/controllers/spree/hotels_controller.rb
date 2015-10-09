module Spree
  class HotelsController < Spree::StoreController
    helper 'spree/products'
    respond_to :html
    include ApplicationHelper
    
    before_action :get_hotels, only: [:list, :grid, :block]

    def index
    end
    
    def list
      @property_types = Spree::PropertyType.all
      search = Spree::Product.ransack(params[:q])
      @products = search.result.hotels
      property_ids = get_properties_ids_from_params
      @products = @products.with_property_ids(property_ids)
      @products = @products.order(params[:sort]) if params[:sort]
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

    def get_hotels
    end

    def get_properties_ids_from_params
      big_list = []
      @property_types.each do |property_type|
        string = params[ptid(property_type)]
        list = string.split('_') rescue []
        big_list += list
      end
      big_list
    end

  end
end