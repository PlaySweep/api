class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.references :slate, foreign_key: true
      t.references :owner, foreign_key: true
      t.string :field

      t.timestamps
    end
  end
end
