class Spree::QuestionGroup < ActiveRecord::Base
  has_many  :questions, inverse_of: :question_group
  validates :name, presence: true
  
  accepts_nested_attributes_for :questions
end
