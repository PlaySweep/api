class IndicativeTrackEventNewUserJob < ApplicationJob
  queue_as :low

  def perform user_id
    unless user_id.nil?
      user = User.find(user_id)
      Indicative::TrackEvent.new_user(user: user)
    end
  end
end