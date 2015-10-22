module Spree
  class StaticDeal < Spree::Base
    translates :name, :description,fallbacks_for_empty_translations: true
    accepts_nested_attributes_for :translations
    has_attached_file :attachment,
                      :convert_options => { :all => '-strip -auto-orient' }
    validates_attachment :attachment, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  end
end