class FillingFieldsOnAirports < ActiveRecord::Migration
  def change
    Airport.all.each do |airport|
      airport.name_slug = normalize(airport.name)
      airport.location_slug = normalize(airport.location)
      airport.save
    end
  end

  def normalize(phrase)
    phrase = I18n.transliterate(phrase)
    phrase = phrase.downcase.gsub(/[^a-z0-9\s]/i, '')
    phrase.squish
  end
end
