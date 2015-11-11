class Spree::Question < ActiveRecord::Base
  belongs_to :question_group, inverse_of: :questions
  has_many   :answers
  
  default_scope { order(:position) }

  validates :question_group, :question_text, :presence => true
  serialize :validation_rules
  
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Spree::Question.model_name
      end
    end

    super
  end
  
  def rules
    validation_rules || {}
  end

  # answer will delegate its validation to question, and question
  # will inturn add validations on answer on the fly!
  def validate_answer(answer)
    if rules[:presence].to_b
      answer.validates_presence_of :answer_text
    end

    if rules[:minimum].present? || rules[:maximum].present?
      min_max = { minimum: rules[:minimum].to_i }
      min_max[:maximum] = rules[:maximum].to_i if rules[:maximum].present?

      answer.validates_length_of :answer_text, min_max
    end
    
    
  end

  def required?
    rules[:presence].to_b
  end

  def greater_than_or_equal_to
    rules[:greater_than_or_equal_to]
  end

  def less_than_or_equal_to
    rules[:less_than_or_equal_to]
  end

  def min_max_params
    params = {}
    params[:min] = greater_than_or_equal_to if greater_than_or_equal_to.present?
    params[:max] = less_than_or_equal_to if less_than_or_equal_to.present?
    params
  end
  
  def default_value
    rules[:default_value]
  end
  
  def include_blank?
    rules[:include_blank].to_b if rules[:include_blank].present?
  end

  def step
    rules[:step]  
  end

end
