class House
  include Resource
  attr_accessor :id, :destination, :image_uri, :house_type, :name, :details_uri,
      :prices, :api
end