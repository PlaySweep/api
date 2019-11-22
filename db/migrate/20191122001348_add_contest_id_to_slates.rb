class AddContestIdToSlates < ActiveRecord::Migration[5.2]
  def change
    add_column :slates, :contest_id, :integer, foreign_key: true, index: true
  end
end
