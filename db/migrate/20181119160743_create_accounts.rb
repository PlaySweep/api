class CreateAccounts< ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :type, default: "Account"
      t.timestamps
    end
  end
end
