class AddPaxToSpreeAnswerGroups < ActiveRecord::Migration
  def change
     add_column :spree_answer_groups, :pax_id, :integer
  end
end
