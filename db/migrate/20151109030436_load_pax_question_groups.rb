class LoadPaxQuestionGroups < ActiveRecord::Migration
  def up
    Rake::Task['db:load_question_groups'].invoke
  end

  def down
  end
end
