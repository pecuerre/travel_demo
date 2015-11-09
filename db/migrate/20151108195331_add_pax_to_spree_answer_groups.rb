class AddPaxToSpreeAnswerGroups < ActiveRecord::Migration
  def change
    add_reference :spree_answer_groups, :pax, index: true, foreign_key: true
  end
end
