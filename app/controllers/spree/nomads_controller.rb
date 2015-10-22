class Spree::NomadsController < Spree::StoreController
  before_action :set_nomad, only: [:show, :edit, :update, :destroy]

  # GET /nomads/new
  def new
    @nomad = Spree::Nomad.new
  end

  # POST /nomads
  # POST /nomads.json
  def create
    @nomad = Spree::Nomad.new(nomad_params)
    status = verify_google_recptcha(ENV['RECAPTCHA_PRIVATE_KEY'],params["g-recaptcha-response"])
    respond_to do |format|
      if @nomad.save && status
        if Spree::NomadMailer.user_registered(@nomad).deliver
          flash[:success] = t('delivery_success')
        else
          flash[:error] = t('delivery_error')
        end
        format.html { redirect_to root_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @nomad.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nomad
      @nomad = Spree::Nomad.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nomad_params
      params.require(:nomad).permit(:first_name, :last_name, :age, :email, :contry, :destination, :reason, :expect, :skills)
    end
end
