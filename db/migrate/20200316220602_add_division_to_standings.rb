class AddDivisionToStandings < ActiveRecord::Migration[5.2]
  def change
    add_column :standings, :division, :string
  end
end
