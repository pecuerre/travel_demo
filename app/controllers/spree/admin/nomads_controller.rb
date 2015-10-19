module Spree
  module Admin
    class NomadsController < Spree::Admin::ResourceController

      before_action :set_nomad, only: [:show, :edit, :update, :destroy]

  # GET /nomads
  # GET /nomads.json
  def index
    @nomads = Nomad.all
  end

  # GET /nomads/1
  # GET /nomads/1.json
  def show
  end

  # GET /nomads/new
  def new
    @nomad = Nomad.new
  end

  # GET /nomads/1/edit
  def edit
  end

  # POST /nomads
  # POST /nomads.json
  def create
    @nomad = Nomad.new(nomad_params)

    respond_to do |format|
      if @nomad.save
        format.html { redirect_to '/admin/nomads', notice: 'Nomad was successfully created.' }
        format.json { render action: 'show', status: :created, location: @nomad }
      else
        format.html { render action: 'new' }
        format.json { render json: @nomad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nomads/1
  # PATCH/PUT /nomads/1.json
  def update
    respond_to do |format|
      if @nomad.update(nomad_params)
        format.html { redirect_to '/admin/nomads', notice: 'Nomad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nomad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nomads/1
  # DELETE /nomads/1.json
  def destroy
    @nomad.destroy
    respond_to do |format|
      format.html { redirect_to nomads_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nomad
      @nomad = Nomad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nomad_params
      params.require(:nomad).permit(:first_name, :last_name, :age, :email, :contry, :destination, :reason, :expect, :skills)
    end
end
  end
end