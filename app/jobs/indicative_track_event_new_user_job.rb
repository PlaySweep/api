class IndicativeTrackEventNewUserJob < ApplicationJob
  queue_as :low

  def perform user_id
    user = User.find(user_id)
    Indicative::TrackEvent.new_user(user: user)
  end
end