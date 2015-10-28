class Destination < ActiveRecord::Base

  def self.like_name(name)
    Destination.find_by_sql("select * from destinations where LOWER(name) like '%#{name.downcase}%' limit 10")
  end

end
