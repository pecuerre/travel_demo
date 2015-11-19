class House
  include Resource
  attr_accessor :id, :destination, :main_image_uri, :house_type, :name, :details_uri,
      :prices, :api, :rooms_uri, :images_uris, :services, :checkin_time, :checkout_time,
      :owner, :rooms, :destination_id, :availabilities

  def images
    images_uris
  end

  def variant_images
    images_uris
  end

  def destination_taxon
    destination
  end

  def price

  end
end