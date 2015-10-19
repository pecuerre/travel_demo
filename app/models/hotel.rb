class Hotel
  include Resource
  attr_accessor :address, :city, :state, :country, :image_uri,
                :low_rate, :high_rate, :chain, :rating, :latitude, :longitude,
                :name_slug, :address_slug, :reviews, :room_type, :meal_plan

  def stars
    if @rating
      [@rating.floor, 5].min
    else
      4
    end
  end

  def image
    if @api == :expedia and @image_uri == 'http://images.travelnow.com'
        @image_uri = 'deals-01.jpg'
    end
    @image_uri
  end

end