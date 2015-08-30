module Spree
  class PropertiesController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

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

  end
end