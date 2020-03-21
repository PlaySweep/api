class UpdateCardsToPolymorphic < ActiveRecord::Migration[5.2]
  class Card < ApplicationRecord; end

  def up
    add_reference :cards, :cardable, polymorphic: true, index: true

    Card.find_each { |card| card.update_attributes(cardable_type: "Slate", cardable_id: card.slate_id) }

    remove_column :cards, :slate_id, :integer
  end

  def down
    remove_column :cards, :cardable_type, :string
    remove_column :cards, :cardable_id, :integer
    add_column :cards, :slate_id, :integer
  end
end
