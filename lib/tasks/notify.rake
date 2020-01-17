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
    notification_type: "SILENT_PUSH"
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

def announcement user:
  begin
    notification = "Hey #{user.first_name}, we're closing in on Championship weekend and there are even more ways to win #{user.current_team.abbreviation} prizes 👀"
    content = "Score the most points amongst your fellow #{user.current_team.abbreviation} fans for the week and take home a #{user.current_team.abbreviation} Playoff Sweatshirt!"
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: notification, 
      notification_type: "SILENT_PUSH"
    )
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: content, 
      notification_type: "NO_PUSH"
    )
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      },
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
  rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
    # user.update_attributes(active: false)
  end
end

def targeted_messaging user: 
  begin
    notification = "If you're seeing this #{user.first_name}, you are still in the hunt in the Road to Super Bowl LIV 🏈"
    content = "You're in exclusive club territory now, #{user.first_name}. And you still have a few more days left to make that push up the leaderboard and win a trip to Super Bowl LIV - good luck!"
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: notification, 
      notification_type: "SILENT_PUSH"
    )
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: content, 
      notification_type: "NO_PUSH"
    )
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      },
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
  rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
    
  end
end

def notify user: 
  begin
    notification = "Championship week is here! Get your answers in for the Road to the NFL Super Bowl LIV."
    content = "It's your last week to make a move up the leaderboard and win a trip to Super Bowl LIV! Tap below to play 👇"
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: notification, 
      notification_type: "SILENT_PUSH"
    )
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: content, 
      notification_type: "NO_PUSH"
    )
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      },
      {
        content_type: :text,
        title: "Status",
        payload: "STATUS"
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
  rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
    
  end
end