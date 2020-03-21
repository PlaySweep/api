class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.string :description
      t.integer :order
      t.integer :status, default: 0
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
