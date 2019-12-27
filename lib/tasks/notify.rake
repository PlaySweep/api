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
  message = "Hey #{user.first_name}, your $20 Drizly credit is still available!"
  FacebookMessaging::Standard.deliver(
    user: user, 
    message: message, 
    notification_type: "REGULAR"
  )
  content = "We noticed you still haven't set up your account to receive your earned $20 Drizly credit - tap below to finish up and we'll take care of the rest!"
  FacebookMessaging::Standard.deliver(
    user: user, 
    message: content, 
    notification_type: "NO_PUSH"
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

def notify_drizly user:, expiration:
  message = "Congratulations #{user.first_name}, a $20 credit has been successfully added to your Drizly account!"
  FacebookMessaging::Standard.deliver(
    user: user, 
    message: message, 
    notification_type: "REGULAR"
  )
  content = "You're now ready to stock up with #{user.account.friendly_name} for the weekend.\n\nFYI, you have until #{expiration} to use your credit so get in there 🕑"
  FacebookMessaging::Standard.deliver(
    user: user, 
    message: content, 
    notification_type: "NO_PUSH"
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
        content = "#{week} is here! Tap to play for a chance at winning more #{user.current_team.abbreviation} prizes."
        FacebookMessaging::Standard.deliver(
          user: user, 
          message: content, 
          notification_type: "SILENT_PUSH"
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
        content = "#{week} is here! Tap to play for a chance at winning more #{user.current_team.abbreviation} prizes."
        FacebookMessaging::Standard.deliver(
          user: user, 
          message: content, 
          notification_type: "SILENT_PUSH"
        )
        FacebookMessaging::Button.deliver(
          user: user,
          title: "Confirm account",
          message: "Just a few more steps away...",
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

def announcement users:
  users.each_with_index do |user, index|
    begin
      if user.confirmed && user.current_team.present?
        content = "Did you know that you can now earn Bud Light swag when you refer your friends? Tap for more."
        FacebookMessaging::Standard.deliver(
          user: user, 
          message: content, 
          notification_type: "SILENT_PUSH"
        )
        quick_replies = FacebookParser::QuickReplyObject.new([
          {
            content_type: :text,
            title: "Share",
            payload: "SHARE"
          }
        ]).objects
        FacebookMessaging::Button.deliver(
          user: user,
          title: "Share and earn",
          message: "Introducing Referral Milestones!\n\nFrom in-app prizes to Bud Light swag and game tickets - earn awesome prizes when you invite your friends to play!",
          url: "#{ENV['WEBVIEW_URL']}/invite/#{user.slug}",
          quick_replies: quick_replies,
          notification_type: "NO_PUSH"
        )
      end
      sleep 30 if index % 750 == 0
    rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
      # user.update_attributes(active: false)
    end
  end
end