module ApplicationHelper

	def name_to_link(entity)
		entity.name.downcase.sub(' ', '-')
	end

	def is_property_in_url?(pp)
		false
	end

	def add_property_to_url(pp)
		pt = "pt#{pp.property_type.id}"
		list = params[pt]
		list = "" unless list
		list = list.split('_')
		list << pp.id.to_s
		list = list.uniq
		str = list.join('_')
		params.merge(pt => str)
	end

	def remove_property_from_url(pp)

	end
end
