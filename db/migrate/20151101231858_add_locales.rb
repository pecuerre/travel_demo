class AddLocales < ActiveRecord::Migration
  def change
    SpreeI18n::Config.available_locales = [:en, :es] # displayed on translation forms
    SpreeI18n::Config.supported_locales = [:en, :es] 
  end
end
