module ApplicationHelper

	def name_to_link(entity)
		entity.name.downcase.sub(' ', '-')
	end
end
