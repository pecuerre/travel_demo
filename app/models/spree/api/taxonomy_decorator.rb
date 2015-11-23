Spree::Taxonomy.class_eval do |clazz|

  # Allow create records of entity nested since attributes.
  accepts_nested_attributes_for :taxons

end