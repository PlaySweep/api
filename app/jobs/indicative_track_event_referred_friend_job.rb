class IndicativeTrackEventReferredFriendJob < ApplicationJob
  queue_as :low

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.referred_friend(user: user)
  end
end