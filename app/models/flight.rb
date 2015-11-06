class Flight
  include Resource
  attr_accessor :airline, :duration_in_minutes,
                :departure_flights, :returning_flights,
                :image_uri, :flight_type

  def flight_numbers
    departure_flight_numbers = @departure_flights.collect{|f| f.flight_number}
    returning_flight_numbers = @returning_flights.collect{|f| f.flight_number}
    departure_flight_numbers + returning_flight_numbers
  end

  def image
    case airline
      when 'Aeromar'
        'assets/airlines/aeromar.png'
      when 'Aeromexico'
        'assets/airlines/aeromexico.png'
      when 'Interjet'
        'assets/airlines/interjet.png'
      when 'Delta Air Lines'
        'assets/airlines/delta.png'
      when 'Alaska Airlines'
        'assets/airlines/alaska.png'
      when 'American Airlines'
        'assets/airlines/aa.png'
      when 'Copa Airlines'
        'assets/airlines/copa.png'
      when 'US Airways'
        'assets/airlines/usair.png'
      when 'United Air Lines'
        'assets/airlines/united.png'
      when 'Múltiples'
        'assets/airlines/multi.png'
      else
        @image_uri
    end
  end
end

class Departure
  attr_accessor :airline, :duration_in_minutes, :departure_date_time,
                :arrival_date_time, :terminal, :departure_airport,
                :departure_airport_code, :arrival_airport, :arrival_airport_code,
                :flight_number, :booking_class
end