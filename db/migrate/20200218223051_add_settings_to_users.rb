class AddSettingsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :settings, :jsonb, default: {}
  end
end
