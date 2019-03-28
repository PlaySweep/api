class BudweiserPreference < Preference
  belongs_to :team, foreign_key: :owner_id, optional: true

  jsonb_accessor :data,
      owner_id: [:integer, default: nil],
      slate_messaging: [:boolean, default: true]

  after_update :subscribe_user

  private

  def subscribe_user
    FacebookMessaging::Broadcast.subscribe_broadcast(self) if saved_change_to_owner_id?
  end
end