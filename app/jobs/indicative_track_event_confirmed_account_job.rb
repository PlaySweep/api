class IndicativeTrackEventConfirmedAccountJob < ApplicationJob
  queue_as :low

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.confirmed_account(user: user)
  end
end