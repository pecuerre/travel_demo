module Spree
  class QuestionGroupsController < Spree::StoreController
    
    def index
      @question_groups = QuestionGroup.all
      respond_with(@question_groups)
    end

  end
end
