class AddStartDateAndEndDateToRewards < ActiveRecord::Migration[5.2]
  def change
    add_column :rewards, :start_date, :datetime, default: Time.now
    add_column :rewards, :end_date, :datetime
  end
end
