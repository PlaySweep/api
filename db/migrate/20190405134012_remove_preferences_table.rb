class RemovePreferencesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :preferences do
      
    end
  end
end
