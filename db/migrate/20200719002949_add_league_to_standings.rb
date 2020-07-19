class AddLeagueToStandings < ActiveRecord::Migration[5.2]
  def change
    add_column :standings, :league, :string
  end
end
