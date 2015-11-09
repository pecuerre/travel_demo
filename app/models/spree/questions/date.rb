module Spree
  module Questions
    class Date < Spree::Question
      def validate_answer(answer)
        super(answer)

        if rules[:presence].to_bool || answer.answer_text.present?
          begin  ::Date.parse(answer.answer_text.to_s)
          rescue ArgumentError => e
            answer.errors.add(:answer_text, :invalid)
          end
        end
      end
    end
  end
end
