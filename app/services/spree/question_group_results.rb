module Spree
  class QuestionGroupResults < Spree::BaseService
    attr_accessor :question_group

    # extracts question along with results
    # each entry will have the following:
    # 1. question type and question id
    # 2. question text
    # 3. if aggregatable, return each option with value
    # 4. else return an array of all the answers given
    def extract
      @question_group.questions.collect do |question|
        results =
          case question
          when Spree::Questions::Select, Spree::Questions::Radio,
            Spree::Questions::Checkbox
            answers = question.answers.map(&:answer_text).map do |text|
              text.split(',') if !text.nil?
            end
            answers = answers.flatten
            answers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }
          when Spree::Questions::Short, Spree::Questions::Date,
            Spree::Questions::Long, Spree::Questions::Numeric
            question.answers.pluck(:answer_text)
          end

        QuestionResult.new(question: question, results: results)
      end
    end
  end
end
