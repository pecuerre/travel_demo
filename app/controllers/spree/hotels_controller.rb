module Spree
  class HotelsController < Spree::StoreController
    helper 'spree/products'
    respond_to :html
    
    before_action :get_holels, only: [:list, :grid, :block]

    def index
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
      def get_holels
        @products = Spree::Product.all
      end

  end
end