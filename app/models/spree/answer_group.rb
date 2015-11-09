class Spree::AnswerGroup < ActiveRecord::Base
  belongs_to :question_group
  belongs_to :pax
  belongs_to :user
  has_many   :answers, inverse_of: :answer_group, autosave: true, dependent: :destroy
  has_many   :questions, through: :answers

  accepts_nested_attributes_for :answers

  def sorted_answers
    # Use sort, not order, as the answers may not yet be saved in the database
    answers.sort_by{|a| a.question.position}
  end

  def answer_by_label(label)
    answers.find {|a| a.question.label == label}
  end

  def answer_to(label)
    answer_by_label(label).try(:answer_text)
  end
  
  def answer_to_sym(label_sym)
    answers.find {|a| a.question.label.parameterize.underscore.to_sym == label_sym}.try(:answer_text)
  end

end
