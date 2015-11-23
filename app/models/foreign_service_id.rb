class ForeignServiceId < ActiveRecord::Base

  belongs_to :taxon, :foreign_key => :taxon_id, :inverse_of => :foreign_service_ids

end
