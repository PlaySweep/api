class SendLosingSlateMessageJob < BudweiserJob
  @queue = :send_losing_slate_message_job

  def perform user_id
    user = BudweiserUser.find(user_id)
    FacebookMessaging::Standard.deliver(user, "#{user.first_name}, unfortunately you didn’t get all 3 right from your Budweiser Sweep card.", "REGULAR")
    FacebookMessaging::Standard.deliver(user, "On the bright side, there are some more Sweep questions available that you can answer by typing 'More contests' below 👇", "SILENT_PUSH")
    # FacebookMessaging::TextButton.deliver(user, "See Available Contests", "On the bright side, there are some more questions available that you can answer by typing 'More contests' below 👇", "SILENT_PUSH")
  end
end