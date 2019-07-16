class RemoveDataFromPrizes < ActiveRecord::Migration[5.2]
  def change
    remove_column :prizes, :data, :jsonb
  end
end
