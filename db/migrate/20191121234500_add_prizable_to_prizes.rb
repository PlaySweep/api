class AddPrizableToPrizes < ActiveRecord::Migration[5.2]
  def change
    add_reference :prizes, :prizeable, polymorphic: true, index: true
  end
end
