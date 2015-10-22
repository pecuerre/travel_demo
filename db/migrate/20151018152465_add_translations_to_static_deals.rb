class AddTranslationsToStaticDeals < ActiveRecord::Migration
  def change
    params = { :name => :string, :description => :text }
    Spree::StaticDeal.create_translation_table!(params, { :migrate_data => true })
  end
end
