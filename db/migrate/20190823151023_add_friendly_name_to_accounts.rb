class AddFriendlyNameToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :friendly_name, :string
  end
end
