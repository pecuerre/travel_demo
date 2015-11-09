module Spree
  module Questions
    class Select < Spree::Question
      validates :answer_options, :presence => true

      def options
        answer_options.split(/\r?\n/)
      end

      def validate_answer(answer)
        super(answer)

        if rules[:presence].to_bool || answer.answer_text.present?
          answer.validates_inclusion_of :answer_text, :in => options
        end
      end
    end
  end
end
