class AddAppNameToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :app_name, :string
  end
end
