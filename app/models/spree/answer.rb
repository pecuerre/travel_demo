class Spree::Answer < ActiveRecord::Base
  belongs_to :answer_group, inverse_of: :answers
  belongs_to :question
  
  validates :question, :answer_group, presence: true
  validate  :verify_answer_text, :if => "question.present?"
  
  private
  def verify_answer_text
    question.validate_answer(self)
  end
  
end
