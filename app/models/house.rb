class House
  include Resource
  attr_accessor :id, :destination, :main_image_uri, :house_type, :name, :details_uri,
      :prices, :api, :rooms_uri, :images_uris, :services, :checkin_time, :checkout_time,
      :owner, :rooms, :destination_id
end