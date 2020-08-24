class AddCounterCacheToSlates < ActiveRecord::Migration[5.2]
  def self.up
    add_column :slates, :incomplete_events_count, :integer, null: false, default: 0

    add_column :slates, :ready_events_count, :integer, null: false, default: 0

    add_column :slates, :complete_events_count, :integer, null: false, default: 0

    add_column :slates, :closed_events_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :slates, :incomplete_events_count

    remove_column :slates, :ready_events_count

    remove_column :slates, :complete_events_count

    remove_column :slates, :closed_events_count
  end
end
