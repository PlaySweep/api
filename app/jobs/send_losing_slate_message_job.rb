class SendLosingSlateMessageJob < ApplicationJob
  @queue = :send_losing_slate_message_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    FacebookMessaging::Standard.deliver(user, "#{user.first_name}, unfortunately you didn’t get all 3 right from your Budweiser Sweep card.", "SILENT_PUSH")
    FacebookMessaging::TextButton.deliver(user, "See Available Contests", "On the bright side, there are some more contests available that you can answer by tapping below 👇", "SILENT_PUSH")
  end
end