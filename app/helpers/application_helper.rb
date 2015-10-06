module ApplicationHelper

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
end
