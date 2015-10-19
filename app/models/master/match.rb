module Master
  class Match

    @@stop_words = %w(&amp; & all inclusive spa resort - the at and or hotel)

    # constantemente se debe estar mejorando.
    # lo ideal es determinar cuando 2 hotels son los mismo por sus coordenadas geográficas,
    # pero price_travel no birnda esta información
    def self.hotels_match(hotel_1, hotel_2)
      hotel_1.name_slug == hotel_2.name_slug ||
          hotel_1.address_slug == hotel_2.address_slug
    end

    def self.flights_match(flight_1, flight_2)
      return flight_1.flight_numbers.sort == flight_2.flight_numbers.sort
    end

    def self.normalize(phrase)
      phrase = I18n.transliterate(phrase)
      phrase = phrase.downcase.gsub(/[^a-z0-9\s]/i, '')
      phrase.squish!
      phrase = phrase.split(' ')
      phrase.select! {|w| not @@stop_words.include?(w)}
      phrase.join(' ')
    end

  end
end