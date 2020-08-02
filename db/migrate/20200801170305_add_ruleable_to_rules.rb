class AddRuleableToRules < ActiveRecord::Migration[5.2]
  def change
    add_reference :rules, :ruleable, polymorphic: true, index: true
  end
end
