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
    notification = "Hey #{user.first_name}, I think I have an easy way for you to add a #{user.current_team.abbreviation} Playoff Sweatshirt to your wardrobe 👀"
    content = "In addition to chasing that trip to the Super Bowl, you can now earn some points for the #{user.current_team.abbreviation} contest each week and take home a Playoff Sweatshirt! Details inside 👇"
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
    notification = "Congrats, #{user.first_name}! You're a top performer in the Race to the NFL Super Bowl LIV leaderboard!"
    content = "We still have a few more weeks left, so study those questions hard and keep bringing those die hard sports friends of yours to help rise up the board!"
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
      },
      {
        content_type: :text,
        title: "Play again",
        payload: "PLAY"
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
  rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
    
  end
end