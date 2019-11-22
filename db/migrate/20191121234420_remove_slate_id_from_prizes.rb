class RemoveSlateIdFromPrizes < ActiveRecord::Migration[5.2]
  def change
    remove_column :prizes, :slate_id, :integer
  end
end
