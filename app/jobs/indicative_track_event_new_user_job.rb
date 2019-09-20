class IndicativeTrackEventNewUserJob < ApplicationJob
  @queue = :indicative_track_event_new_user_job

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.new_user(user: user)
  end
end