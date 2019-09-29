class IndicativeTrackEventPlayedContestJob < ApplicationJob
  @queue = :indicative_track_event_played_contest_job

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.played_contest(user: user)
  end
end