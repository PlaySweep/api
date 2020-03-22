class UpdateSweepsToPolymorphic < ActiveRecord::Migration[5.2]
  class Sweep < ApplicationRecord; end

  def up
    add_reference :sweeps, :sweepable, polymorphic: true, index: true

    Sweep.find_each { |sweep| sweep.update_attributes(sweepable_type: "Slate", sweepable_id: sweep.slate_id) }

    remove_column :sweeps, :slate_id, :integer
  end

  def down
    remove_column :sweeps, :sweepable_type, :string
    remove_column :sweeps, :sweepable_id, :integer
    add_column :sweeps, :slate_id, :integer
  end
end
