module Spree
  class QuestionResult < Spree::BaseService
    include ActiveModel::Serialization

    attr_accessor :question, :results

    def active_model_serializer
      Spree::QuestionResultSerializer
    end
  end
end
