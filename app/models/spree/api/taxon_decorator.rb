Spree::Taxon.class_eval do |clazz|
  before_create :set_parent_taxonomy

  # Used to link taxons with price_travel, holiplus and any other service.
  has_many :foreign_service_ids, :dependent => :destroy

  # Allow create records of entity nested since attributes.
  accepts_nested_attributes_for :children
  accepts_nested_attributes_for :foreign_service_ids

  # Add new attrs for query params (search options) in the request.
  self.whitelisted_ransackable_associations = %w[taxonomy]

  private

  # Set parent taxonomy when taxonomy_id is null.
  def set_parent_taxonomy
    self.taxonomy_id ||= self.parent.taxonomy_id if self.parent
  end

end