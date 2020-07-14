class AddProfileIdToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_reference :players, :profile, foreign_key: true
  end
end
