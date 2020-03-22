class AddDataToQuizzes < ActiveRecord::Migration[5.2]
  def change
    add_column :quizzes, :data, :jsonb, default: {}
  end
end
