class WelcomeBackJob < ApplicationJob
  queue_as :critical

  def perform user_id
    user = User.find(user_id)
    welcome_back_copy = user.account.copies.where(category: "Welcome Back").sample.message
    welcome_back_interpolated = welcome_back_copy % { account_name: user.account.app_name, first_name: user.first_name }
    if user.confirmed
      quick_replies = FacebookParser::QuickReplyObject.new([
        {
          content_type: :text,
          title: "Share",
          payload: "SHARE"
        }
      ]).objects
      FacebookMessaging::Standard.deliver(
        user: user,
        message: "#{welcome_back_interpolated}",
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Play now",
        message: "There are more contests to play!",
        url: "#{ENV["WEBVIEW_URL"]}/messenger/#{user.facebook_uuid}",
        quick_replies: quick_replies,
        notification_type: "NO_PUSH"
      )
    else
      FacebookMessaging::Standard.deliver(
        user: user,
        message: "#{welcome_back_interpolated}\n\nI notice you still haven't confirmed your account with us.",
        notification_type: "NO_PUSH"
      )
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Confirm account",
        message: "Just tap below to finish up a few quick details and get started winning prizes 👇",
        url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
        notification_type: "NO_PUSH"
      )
    end
  end
end