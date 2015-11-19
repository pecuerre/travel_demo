module ApplicationHelper


	####################################################################
	# Properties
	####################################################################

	def name_to_link(entity)
		entity.name.downcase.sub(' ', '-')
	end

	def ptid(pt)
		"pt#{pt.id}"
	end

	def is_property_in_url?(pp)
		pt = ptid(pp.property_type)
		list = params[pt]
		list = list.split('_') rescue []
		list.include?(pp.id.to_s)
	end

	def add_property_to_url(pp)
		pt = ptid(pp.property_type)
		list = params[pt]
		list = "" unless list
		list = list.split('_')
		list << pp.id.to_s
		list = list.uniq
		str = list.join('_')
		params.merge(pt => str, :lastpt => pt)
	end

	def remove_property_from_url(pp)
		pt = ptid(pp.property_type)
		list = params[pt]
		list = "" unless list
		list = list.split('_')
		list.delete(pp.id.to_s)
		str = list.join('_')
		params.merge(pt => str, :lastpt => pt)
	end

	def is_sort_in_url?(p)
		params[:sort] == p
	end

	def add_sort_to_url(p)
		params.merge(:sort => p)
	end

	####################################################################
	# Answers and Questions
	####################################################################

	def render_answer_form_helper(form)
    answer = form.object
    partial = answer.question.type.to_s.split("::").last.downcase
    render partial: "spree/answers/#{partial}", locals: { f: form, answer: answer }
  end

	####################################################################
	# Flights
	####################################################################

	def take_off_time(flight)
		datetime_formatted(flight.departure_flights.first.departure_date_time)
	end

	def landing_time(flight)
		datetime_formatted(flight.departure_flights.first.arrival_date_time)
	end

	def datetime_formatted(moment)
		moment.strftime("%^a %^b %d, %Y %H:%M %p")
	end

	def flight_duration(flight)
		seconds = flight.departure_flights.first.duration_in_minutes
		hours = seconds / 1.hour
		minutes = seconds % 1.hour / 1.minute
		"%02d HOURS, %02d MINUTES" % [hours, minutes]
	end
end
