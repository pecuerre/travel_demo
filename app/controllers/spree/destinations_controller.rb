module Spree
  class DestinationsController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
    
    def grid
    end
    
    def block
    end
    
    def detail
    end

  end
end