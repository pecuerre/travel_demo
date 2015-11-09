module Spree
  class AnswerGroupsController < Spree::StoreController
    before_filter :find_question_group!
    skip_before_filter :verify_authenticity_token, :only => [:create]

    def new
      @answer_group_builder = Spree::AnswerGroupBuilder.new(answer_group_params)
    end

    def create
      @answer_group_builder = Spree::AnswerGroupBuilder.new(answer_group_params)
      
      if @answer_group_builder.save
        redirect_to question_groups_path
      else
        render :new
      end
    end

    private
    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def answer_group_params

      if params[:answer_group].present?
        left_keys = params.keys.select { |key| key.to_s.match(/_left_part/) }
        left_keys.each do |key|
          key_value = key_val_feet_and_inches(key)

          next unless params[:answer_group][key_value[0]].present?
          params[:answer_group][key_value[0]][:answer_text] = key_value[1]   
        end
      end

      answer_params = { params: params[:answer_group] }
      answer_params.merge(user: spree_current_user, question_group: @question_group)
    end

  end
end
