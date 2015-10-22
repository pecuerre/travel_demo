Spree::HomeController.class_eval do
  helper 'spree/products'
  respond_to :html
  
  def index2
    # @destinations = Spree::Taxon.find_by(:name => "Destinations")
    # TODO esto hay que mejorarlo no debe quedar así con los ids
    # @destination_big = Spree::Taxon.find_by_name('Destinations').products.includes(:translations).where(id:[31, 142, 767]).to_a.uniq
    @destination_big = []
    @static_deals = Spree::StaticDeal.all
  end

end