class IndicativeTrackEventPlayedContestJob < ApplicationJob
  queue_as :low

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.played_contest(user: user)
  end
end