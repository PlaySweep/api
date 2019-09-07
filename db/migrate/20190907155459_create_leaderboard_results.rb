class CreateLeaderboardResults < ActiveRecord::Migration[5.2]
  def change
    create_table :leaderboard_results do |t|
      t.references :user, foreign_key: true
      t.references :leaderboard_history, foreign_key: true
      t.float :score
      t.integer :rank
    end
  end
end
