class AddAccountIdToProducts < ActiveRecord::Migration[5.2]
  class Product < ApplicationRecord; end

  def up
    add_reference :products, :account, foreign_key: true, index: true
    Product.find_each { |product| product.update_attributes(account_id: 1) }
  end

  def down
    remove_column :products, :account_id, :integer
  end
end
