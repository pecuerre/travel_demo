class CreateSpreeAnswers < ActiveRecord::Migration
  def change
    create_table :spree_answers do |t|
      t.references :answer_group, index: true
      t.references :question, index: true
      t.text :answer_text

      t.timestamps
    end
  end
end
