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

  scope :by_name, ->(team_abbreviation) { where('data @> ?', { abbreviation: team_abbreviation.split('_').map(&:capitalize).join(' ') }.to_json) }
  scope :ordered, -> { order(name: :asc) }
  scope :sponsored, -> { where('data @> ?', { sponsored: true }.to_json) }
  scope :by_division, ->(division) { where('data @> ?', { division: division }.to_json) }
  scope :active, -> { where(active: true) }

  def coordinates
    [lat, long]
  end
  
end