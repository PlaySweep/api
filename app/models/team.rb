class Team < Owner
  resourcify  
  belongs_to :league, foreign_key: :account_id
  has_many :products, foreign_key: :owner_id
  has_many :slates, foreign_key: :owner_id

  scope :by_name, ->(name) { where('owners.name ilike ?', "%#{name}%") }
  scope :ordered, -> { order(name: :asc) }
  scope :sponsored, -> { data_where(sponsored: true) }
  scope :active, -> { where(active: true) }

  after_update :create_broadcast_label

  jsonb_accessor :data,
    entry_image: [:string, default: nil],
    local_image: [:string, default: nil],
    sponsored: [:boolean, default: false],
    initials: [:string, default: nil],
    abbreviation: [:string, default: nil],
    lat: [:float, default: nil],
    long: [:float, default: nil]

  private

  def create_broadcast_label
    if saved_change_to_active?(to: true)
      FacebookMessaging::Broadcast.generate_broadcast_label_for(resource: self)
    end
  end

  def destroy_broadcast_label
    if saved_change_to_active?(to: false)
      team = FacebookMessaging::Broadcast.fetch_all_labels.select { |label| label["team"].split(' ')[-1] == id }.pop
      FacebookMessaging::Broadcast.destroy(team["id"])
    end
  end
end