class RemoveTimeWindowFromQuestionSessions < ActiveRecord::Migration[5.2]
  def change
    remove_column :question_sessions, :time_window, :integer
  end
end
