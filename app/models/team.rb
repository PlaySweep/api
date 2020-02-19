class Team < Owner
  resourcify  
  belongs_to :league, foreign_key: :account_id
  has_one :standing, foreign_key: :owner_id
  has_many :products, foreign_key: :owner_id
  has_many :slates, foreign_key: :owner_id
  has_many :players, foreign_key: :owner_id

  store_accessor :data, :entry_image, :local_image, :sponsored,
                        :initials, :abbreviation, :lat, :long,
                        :division, :conference

  scope :by_name, ->(team_abbreviation) { data_where(abbreviation: team_abbreviation.split('_').map(&:capitalize).join(' ')) }
  scope :ordered, -> { order(name: :asc) }
  scope :sponsored, -> { data_where(sponsored: true) }
  scope :by_division, ->(division) { data_where(division: division) }
  scope :active, -> { where(active: true) }

  def coordinates
    [lat, long]
  end
  
end