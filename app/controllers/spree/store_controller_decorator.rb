Spree::StoreController.class_eval do
  before_action :source_count
  # before_action :load_static_contents

  def source_count
    unless params['source'].blank?
      source = SourceCounter.find_or_create_by(source: params['source']) { |s| s.count = 0 }
      source.count += 1
      source.save
    end
  end

end