class NotifyReferrerJob < ApplicationJob
  queue_as :low

  def perform referrer_id, referred_id
    referrer = User.find(referrer_id)
    referred_user = User.find(referred_id)
    # TODO Handle a new way to message for referring
  end
end