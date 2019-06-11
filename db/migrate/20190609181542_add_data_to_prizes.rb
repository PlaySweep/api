class AddDataToPrizes < ActiveRecord::Migration[5.2]
  def change
    add_column :prizes, :data, :jsonb, default: {}
  end
end
