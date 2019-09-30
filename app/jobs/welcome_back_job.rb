class WelcomeBackJob < ApplicationJob
  @queue = :welcome_back_job

  def perform user_id
    user = User.find(user_id)
    welcome_back_copy = user.account.copies.where(category: "Welcome Back").sample.message
    welcome_back_interpolated = welcome_back_copy % { account_name: user.account.app_name, first_name: user.first_name }
    if user.confirmed
      team = user.roles.find_by(resource_type: "Team").try(:resource)
      if team
        quick_replies = FacebookParser::QuickReplyObject.new([
          {
            content_type: :text,
            title: "Status",
            payload: "STATUS"
          },
          {
            content_type: :text,
            title: "Share",
            payload: "SHARE"
          }
        ]).objects
        FacebookMessaging::Standard.deliver(
          user: user,
          message: "#{welcome_back_interpolated}\n\nYou're currently playing for the #{team.abbreviation} - but you can change by typing 'switch'.",
          notification_type: "NO_PUSH"
        )
        FacebookMessaging::Button.deliver(
          user: user,
          title: "Play now",
          message: "There are more #{team.abbreviation} games to play!",
          url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1",
          quick_replies: quick_replies,
          notification_type: "NO_PUSH"
        )
      else
        quick_replies = FacebookParser::QuickReplyObject.new([
          {
            content_type: :text,
            title: "Play without a team",
            payload: "PLAY"
          }
        ]).objects
        FacebookMessaging::Standard.deliver(
          user: user,
          message: "#{welcome_back_interpolated}\n\nYou still haven't selected a team to play with yet.",
          notification_type: "NO_PUSH"
        )
        FacebookMessaging::Button.deliver(
          user: user,
          title: "Select a team",
          message: "Tap below to see a full list of available teams to choose from.",
          url: "#{ENV["WEBVIEW_URL"]}/#{user.id}/teams/initial_load",
          quick_replies: quick_replies,
          notification_type: "NO_PUSH"
        )
      end
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