class Team < Owner
  resourcify  
  belongs_to :league, foreign_key: :account_id
  has_many :products, foreign_key: :owner_id

  scope :ordered, -> { order(name: :asc) }
  scope :sponsored, -> { data_where(sponsored: true) }
  scope :active, -> { where(active: true) }

  jsonb_accessor :data,
    entry_image: [:string, default: nil],
    local_image: [:string, default: nil],
    sponsored: [:boolean, default: false]

  def abbreviation
    name.split(' ')[-1]
  end
end