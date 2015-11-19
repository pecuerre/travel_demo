class LoadPaxQuestionGroups < ActiveRecord::Migration

  # NOTE: sere, migue, esto no se pone aqui, PQR
  def up
    Rake::Task['db:load_question_groups'].invoke
  end

  def down
  end
end
