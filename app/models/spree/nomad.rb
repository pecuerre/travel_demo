class Spree::Nomad < Spree::Base

  validates_presence_of :first_name, :age, :email, :contry, :destination, :reason, :skills, :expect
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

end
