class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :subdomain
      t.string :image
      t.timestamps
    end
  end
end
