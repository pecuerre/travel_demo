module Spree
  class HotelsController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    before_action :get_hotels, only: [:list, :grid, :block]

    def index
      list
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
    def get_hotels
      @products = Spree::Product.sample
    end

  end

  class Product

    class << self

      def generateProduct

        product = OpenStruct.new
        product.name = Faker::Company.name
        product.description=Faker::DizzleIpsum.paragraph(5)
        product.destination = Faker::DizzleIpsum.phrase
        product.destination_taxon = Faker::DizzleIpsum.phrase
        product.variant_images = []
        product.images=[]
        product.price = rand(100...1000)
        product.review=rand(1000)
        product
      end

      def sample
        @products = @@_products ||=
            begin
              products= []
              sample_size=30
              i=0
              while i<sample_size
                products << generateProduct
                i+=1
              end
              products
            end
      end

    end
  end
end