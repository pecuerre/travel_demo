require 'ffaker'

namespace :trip do

	namespace :load do

  	desc 'Loads trip destinations'
  	task :destinations => :environment do
    	require Rails.root + "db/data/destinations"
  	end

  end
end


