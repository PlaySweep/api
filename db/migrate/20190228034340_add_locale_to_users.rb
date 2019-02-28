class AddLocaleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :locale, :string
    add_column :users, :profile_pic, :string
    add_column :users, :zipcode, :string
    add_column :users, :dob, :date
  end
end
