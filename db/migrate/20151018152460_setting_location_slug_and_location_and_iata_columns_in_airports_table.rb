class SettingLocationSlugAndLocationAndIataColumnsInAirportsTable < ActiveRecord::Migration
  def change
    Airport.all.each do |airport|
      airport.location_slug = normalize(airport.location)
      airport.location_and_iata = "#{airport.location} (#{airport.iata})"
      airport.save
    end
  end

  def normalize(phrase)
    phrase = I18n.transliterate(phrase)
    phrase = phrase.downcase.gsub(/[^a-z0-9\s]/i, '')
    phrase.squish
  end
end
