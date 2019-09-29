class IndicativeTrackEventReferredFriendJob < ApplicationJob
  @queue = :indicative_track_event_referred_friend_job

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.referred_friend(user: user)
  end
end