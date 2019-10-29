namespace :prod do

  desc "Notify Active User"
  task :notify => :environment do
    users = User.active
    notify(users: users)
  end

  namespace :system do

    desc "Send New Feature Update"
    task :new_feature => :environment do
      
    end
  end

end

def re_engage_drizly user:
  content = "Hey #{user.first_name}, just a friendly reminder that you still haven't set up your account to receive your earned $20 Drizly credit - tap below if you're still interested and we'll take care of the rest!"
  FacebookMessaging::Standard.deliver(
    user: user, 
    message: content, 
    notification_type: "REGULAR"
  )
  quick_replies = FacebookParser::QuickReplyObject.new([
    {
      content_type: :text,
      title: "Status",
      payload: "STATUS"
    },
    { 
      content_type: :text,
      title: "Play again",
      payload: "PLAY",
      image_url: user.current_team.image
    },
    {
      content_type: :text,
      title: "Share",
      payload: "SHARE"
    }
  ]).objects
  FacebookMessaging::Generic::Promotion.deliver(user: user, quick_replies: quick_replies)
end

def notify_drizly user:
  content = "The $20 Drizly credit that you won has been successfully applied to your account! Click below and you'll be taken straight to Drizly where you can order your #{user.account.friendly_name}!"
  FacebookMessaging::Standard.deliver(
    user: user, 
    message: content, 
    notification_type: "REGULAR"
  )
  quick_replies = FacebookParser::QuickReplyObject.new([
    {
      content_type: :text,
      title: "Status",
      payload: "STATUS"
    },
    { 
      content_type: :text,
      title: "Play again",
      payload: "PLAY",
      image_url: user.current_team.image
    },
    {
      content_type: :text,
      title: "Share",
      payload: "SHARE"
    }
  ]).objects
  FacebookMessaging::Generic::Web.deliver(user: user, quick_replies: quick_replies)
end

def notify users:, week:
  users.each_with_index do |user, index|
    begin
      if user.confirmed && user.current_team.present?
        content = "We're only a few hours away from #{user.current_team.abbreviation} #{week} kickoff! Answer 6 questions tonight and win!"
        FacebookMessaging::Standard.deliver(
          user: user, 
          message: content, 
          notification_type: "REGULAR"
        )
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
        FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
      elsif !user.confirmed
        content = "We're only a few hours away from #{week} kickoff! Answer 6 questions tonight and win!"
        FacebookMessaging::Standard.deliver(
          user: user, 
          message: content, 
          notification_type: "REGULAR"
        )
        FacebookMessaging::Button.deliver(
            user: user,
            title: "Confirm account",
            message: "You're a few steps away from winning #{user.account.app_name} prizes!",
            url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
            notification_type: "NO_PUSH"
          )
      end
      sleep 30 if index % 500 == 0
    rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
      # user.update_attributes(active: false)
    end
  end
end