module Spree
  class HotelsController < Spree::StoreController
    helper 'spree/products'
    respond_to :html
    include ApplicationHelper

    def index
      @property_types = Spree::PropertyType.all

      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products.hotels
      
      @category = params[:category]
      @destination = params[:destination]
      taxons = []
      taxons << Spree::Taxon.find_by(name: @category).id if @category.present?
      taxons << Spree::Taxon.find_by(name: @destination).id if @destination.present?
      @products = @products.in_taxons(taxons) if taxons.present?
      property_ids = get_properties_ids_from_params
      @view = params[:view]
      @products = @products.with_property_ids(property_ids)
      @products = @products.order(params[:sort]) if params[:sort]
    end

    private

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