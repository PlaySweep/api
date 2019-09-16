class AddEarnedByToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :earned_by_id, :integer
    add_column :entries, :reason, :integer, default: 0
  end
end
