class AddCodePrefixToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :code_prefix, :string, default: "SWEEP"
  end
end
