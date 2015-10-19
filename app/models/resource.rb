module Resource
  attr_accessor :id, :name, :description, :prices, :api, :booking_uri, :same_booking_uri

  def cheaper_api
    @prices.min_by{|api| api[1]}[0]
  end

  def cheaper_booking_uri
    @booking_uri[cheaper_api]
  end

end