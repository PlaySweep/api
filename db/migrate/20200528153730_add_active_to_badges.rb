class AddActiveToBadges < ActiveRecord::Migration[5.2]
  def change
    add_column :badges, :active, :boolean, default: true
  end
end
