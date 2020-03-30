class AddFormattedAddressToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :formatted_address, :string
  end
end
