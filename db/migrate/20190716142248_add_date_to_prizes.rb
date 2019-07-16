class AddDateToPrizes < ActiveRecord::Migration[5.2]
  def change
    add_column :prizes, :date, :string
  end
end
