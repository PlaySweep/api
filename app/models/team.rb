class Team < Owner
  resourcify  
  belongs_to :league, foreign_key: :account_id
  has_one :standing, foreign_key: :owner_id
  has_many :products, foreign_key: :owner_id
  has_many :slates, foreign_key: :owner_id
  has_many :players, foreign_key: :owner_id


  scope :by_name, ->(team_abbreviation) { data_where(abbreviation: team_abbreviation.split('_').map(&:capitalize).join(' ')) }
  scope :ordered, -> { order(name: :asc) }
  scope :sponsored, -> { data_where(sponsored: true) }
  scope :by_division, ->(division) { data_where(division: division) }
  scope :active, -> { where(active: true) }

  jsonb_accessor :data,
    entry_image: [:string, default: nil],
    local_image: [:string, default: nil],
    sponsored: [:boolean, default: false],
    initials: [:string, default: nil],
    abbreviation: [:string, default: nil],
    lat: [:float, default: nil],
    long: [:float, default: nil],
    division: [:string, default: nil],
    conference: [:string, default: nil]

  def coordinates
    [lat, long]
  end
  
end