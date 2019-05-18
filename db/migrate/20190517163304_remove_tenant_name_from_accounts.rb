class RemoveTenantNameFromAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :accounts, :tenant, :string
  end
end
