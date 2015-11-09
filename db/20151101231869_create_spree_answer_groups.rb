class CreateSpreeAnswerGroups < ActiveRecord::Migration
  def change
    create_table :spree_answer_groups do |t|
      t.references :question_group, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
