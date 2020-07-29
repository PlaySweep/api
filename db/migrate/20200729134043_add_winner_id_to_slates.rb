class AddWinnerIdToSlates < ActiveRecord::Migration[5.2]
  def change
    add_column :slates, :current_winner_id, :integer, foreign_key: true, index: true
  end
end
