class SendWinningSlateMessageJob < ApplicationJob
  queue_as :low

  def perform user_id, slate_id
    user = User.find(user_id)
    slate = Slate.find(slate_id)
    # TODO Handle a new way to message
  end
end