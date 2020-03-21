class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :description
      t.string :type, default: "Question"
      t.integer :order
      t.references :quiz, foreign_key: true

      t.timestamps
    end
  end
end
