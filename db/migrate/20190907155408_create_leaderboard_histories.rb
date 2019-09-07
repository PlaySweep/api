class CreateLeaderboardHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :leaderboard_histories do |t|
      t.string :name
      t.string :description
      t.references :account, foreign_key: true
    end
  end
end
