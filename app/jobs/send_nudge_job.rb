class SendNudgeJob < ApplicationJob
  queue_as :low

  def perform nudger_id, nudged_id
    nudger = User.find_by(id: nudger_id)
    nudged = User.find_by(id: nudged_id)
    if nudged.confirmed
      # TODO send email notification to play
    else
      # TODO send email notification to sign up
    end
  end
end