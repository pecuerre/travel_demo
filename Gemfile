source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'ransack'
gem 'haml-rails'
# gem 'therubyracer', platforms: :ruby
# gem 'bcrypt', '~> 3.1.7'
# gem 'unicorn'
# gem 'capistrano-rails', group: :development
gem 'figaro'
gem 'aws-sdk'
gem 'rails_admin'

group :development, :test do
  gem 'ffaker'
	gem 'sqlite3'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'pry'
  gem "better_errors"
  gem "binding_of_caller"
end

group :production do
	gem 'rails_12factor'
	gem 'pg'
end

gem 'spree', github: 'spree/spree', branch: '3-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-0-stable'

#gem 'spree_travel_core', github: 'openjaf/spree_travel_core', branch: 'combinations_less'
#gem 'spree_travel_hotel', github: 'openjaf/spree_travel_hotel', branch: 'combinations_less'
gem 'spree_travel_core', path: '../openjaf/spree_travel_core'
gem 'spree_travel_hotel', path: '../openjaf/spree_travel_hotel'
gem 'spree_travel_package', github: 'openjaf/spree_travel_package', branch: '3-0-stable'
gem 'spree_travel_sample', github: 'openjaf/spree_travel_sample', branch: 'combinations_less'
gem 'spree_property_type', github: 'openjaf/spree_property_type', branch: '3-0-stable'
