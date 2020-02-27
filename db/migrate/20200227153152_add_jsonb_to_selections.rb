class AddJsonbToSelections < ActiveRecord::Migration[5.2]
  def change
    add_column :selections, :data, :jsonb, default: {}
  end
end
