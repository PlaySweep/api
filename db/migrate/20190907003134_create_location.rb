class CreateLocation < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.references :user, foreign_key: true
      t.string :city
      t.string :state
      t.string :postcode
      t.string :country
      t.string :country_code

      t.timestamps
    end
  end
end
