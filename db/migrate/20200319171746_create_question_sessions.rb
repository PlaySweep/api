class CreateQuestionSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_sessions do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      t.integer :time_window
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
