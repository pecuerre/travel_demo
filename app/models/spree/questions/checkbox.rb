module Spree
  module Questions
    class Checkbox < Spree::Question
      validates :answer_options, :presence => true

      def options
        answer_options.split(/\r?\n/)
      end

      def validate_answer(answer)
        super(answer)

        if rules[:presence].to_bool || answer.answer_text.present?
          answer.answer_text.split(",").each do |value|
            answer.errors.add(:answer_text, :invalid) unless options.include?(value)
          end
        end
      end
    end
  end
end
