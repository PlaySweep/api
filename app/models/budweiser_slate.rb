class BudweiserSlate < Slate
  belongs_to :team, foreign_key: :owner_id

  scope :for_owner, ->(owner_id) { where(owner_id: owner_id) } 
end