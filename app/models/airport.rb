class Airport < ActiveRecord::Base
  def self.like_location_and_iata(location)
    Airport.find_by_sql("select * from airports where LOWER(location_and_iata) like '%#{location.downcase}%' limit 10")
  end

  def self.like_location_slug(location)
    Airport.find_by_sql("select * from airports where LOWER(location_slug) like '%#{location.downcase}%' limit 10")
  end
end
