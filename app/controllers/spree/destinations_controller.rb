module Spree
  class DestinationsController < Spree::StoreController
    helper 'spree/products'
    respond_to :html
    before_action :get_destinations, only: [:index]

    def index
 #     @searcher = build_searcher(params.merge(include_images: true))
   #   @products = @searcher.retrieve_products
     # @taxonomies = Spree::Taxonomy.includes(root: :children)

    end
    
    def grid
    end
    
    def block
    end
    
    def detail
      @destiny=params[:destiny]
    end

    private
    def get_destinations
      @destinos14={'Habana'=>'dest_habana_m.jpg',
                   'Varadero'=>'dest_varadero_m.jpg',
                   'Santiago de Cuba'=>'dest_santiago_m.jpg',
                   'Valle de Viñales'=>'dest_vinales_m.jpg',};
      @destinos58={'Baracoa'=>'dest_baracoa_m.jpg',
                   'Cayo Coco'=>'dest_ccoco_m.jpg',
                   'Cayo Guillermo'=>'dest_cguillermo_m.jpg',
                   'Cayo Largo'=>'dest_clargo_m.jpg',};
      @destinos912={'Camaguey'=>'dest_camaguey_m.jpg',
                   'Cienfuegos'=>'dest_cienfuegos_m.jpg',
                   'Pinar del Río'=>'dest_pinar_m.jpg',
                   'Trinidad'=>'dest_trinidad_m.jpg',};
    end

  end
end