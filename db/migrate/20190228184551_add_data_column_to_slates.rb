class AddDataColumnToSlates < ActiveRecord::Migration[5.2]
  def change
    add_column :slates, :data, :jsonb, default: {}
  end
end
