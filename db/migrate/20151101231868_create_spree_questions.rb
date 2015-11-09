class CreateSpreeQuestions < ActiveRecord::Migration
  def change
    create_table :spree_questions do |t|
      t.string :type
      t.string :question_text
      t.integer :position
      t.text :answer_options
      t.text :validation_rules
      t.string   :help
      t.boolean  :prefill,           default: false
      t.string   :units
      t.string   :label
      t.references :question_group, index: true

      t.timestamps
    end
  end
end
