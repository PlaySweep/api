class AddAccountIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :account, foreign_key: true, index: true
  end
end
