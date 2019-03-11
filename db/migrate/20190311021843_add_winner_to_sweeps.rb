class AddWinnerToSweeps < ActiveRecord::Migration[5.2]
  def change
    add_column :sweeps, :winner, :boolean, default: false
  end
end
