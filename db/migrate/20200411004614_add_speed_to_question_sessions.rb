class AddSpeedToQuestionSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :question_sessions, :speed, :float
  end
end
