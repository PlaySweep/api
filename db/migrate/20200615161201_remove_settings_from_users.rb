class RemoveSettingsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :settings, :jsonb, default: {}
  end
end
