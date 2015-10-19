module Spree
  module Admin

class StaticDealsController < Spree::Admin::ResourceController
  before_action :set_static_deal, only: [:show, :edit, :update, :destroy]

  # GET /static_deals
  # GET /static_deals.json
  def index
    @static_deals = Spree::StaticDeal.all
  end

  # GET /static_deals/1
  # GET /static_deals/1.json
  def show
  end

  # GET /static_deals/new
  def new
    @static_deal = Spree::StaticDeal.new
  end

  # GET /static_deals/1/edit
  def edit
  end

  # POST /static_deals
  # POST /static_deals.json
  def create
    @static_deal = Spree::StaticDeal.new(static_deal_params)

    respond_to do |format|
      if @static_deal.save
        format.html { redirect_to '/admin/static_deals', notice: 'Static deal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @static_deal }
      else
        format.html { render action: 'new' }
        format.json { render json: @static_deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /static_deals/1
  # PATCH/PUT /static_deals/1.json
  def update
    respond_to do |format|
      if @static_deal.update(static_deal_params)
        format.html { redirect_to '/admin/static_deals', notice: 'Static deal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @static_deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_deals/1
  # DELETE /static_deals/1.json
  def destroy
    @static_deal.destroy
    respond_to do |format|
      format.html { redirect_to '/admin/static_deals' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_static_deal
      @static_deal = Spree::StaticDeal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def static_deal_params
      params.require(:static_deal).permit(:name, :description, :price, :link, :stars, :attachment, translations_attributes: [:id, :locale, :name, :description])
    end
end

  end
  end