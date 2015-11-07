Spree::OptionType.class_eval  do
	
	def self.plans
		with_name('plan').option_values
	end

	def self.with_name(name)
		where(:name => name).first
	end
end