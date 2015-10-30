require Rails.root + "db/common/trip_functions"
include TripFunctions
require "csv"

CSV.foreach(Rails.root + "db/external/flights.csv") do |row|

end
