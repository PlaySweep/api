class IndicativeTrackEventConfirmedAccountJob < ApplicationJob
  @queue = :indicative_track_event_confirmed_account_job

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.confirmed_account(user: user)
  end
end