class CreateQuizzes < ActiveRecord::Migration[5.2]
  def change
    create_table :quizzes do |t|
      t.string :name
      t.string :description
      t.datetime :start_time
      t.string :type, default: "Quiz"
      t.integer :status, default: 0
      t.references :owner, foreign_key: true

      t.timestamps
    end
  end
end
