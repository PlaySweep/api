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
    notification = "⚾️ We have more Budweiser Sweep Trivia contests available, #{user.first_name}!"
    content = "Now you can earn a Save by referring your friends to play! This will allow you to erase a wrong answer and stay in the game."
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: notification, 
      notification_type: "REGULAR"
    )
    # FacebookMessaging::Standard.deliver(
    #   user: user, 
    #   message: content, 
    #   notification_type: "NO_PUSH"
    # )
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    puts "Delivered message to #{user.last_name} (#{user.id})"
  rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
    puts "Deactivate #{user.last_name} (#{user.id})"
    user.update_attributes(active: false)
  end
end

def global_announcement user:
  begin
    notification = "⚾️ We have more Budweiser Sweep Trivia available, #{user.first_name}!"
    content = "Now you can earn a Save by referring your friends to play! This will allow you to erase a wrong answer and stay in the game."
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
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    puts "Delivered message to #{user.last_name} (#{user.id})"
  rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
    puts "Deactivate #{user.last_name} (#{user.id})"
    user.update_attributes(active: false)
  end
end

def re_engage user:
  begin
    notification = "⚾️ The Budweiser Sweep is back for 2020, and we’ve got trivia until the season starts!"
    content = "Finish your account setup below and start winning Budweiser, MLB, and team swag 🍻!"
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: notification, 
      notification_type: "SILENT_PUSH"
    )
    FacebookMessaging::Button.deliver(
        user: user,
        title: "Confirm your account",
        message: content,
        url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
        notification_type: "NO_PUSH"
      )
    puts "Delivered message to #{user.last_name} (#{user.id})"
  rescue
    puts "Deactivate #{user.last_name} (#{user.id})"
    user.update_attributes(active: false)
  end
end

def targeted_messaging user: 
  begin
    notification = "🏈 Who's in the top 20? You are, #{user.first_name}!"
    content = "Even if you don't get to #1, 2nd-20th place win a Sweatshirt for their favorite NFL team - so keep it up!"
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
    if user.confirmed && (user.current_team.abbreviation == "Chiefs" || user.current_team.abbreviation == "49ers")
      notification = "🏈 We're so close, #{user.first_name}. Tap to find out how you can win an autographed football from the Super Bowl MVP!"
      content = "Get all 6 questions right for the Super Bowl contest and you'll have a chance at winning a Super Bowl MVP Autographed Football!\n\nPlus, you can also win a #{user.current_team.abbreviation} Super Bowl Hoodie & Hat by taking 1st place amongst your fellow #{user.current_team.abbreviation} fans on the team leaderboard 📈"
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
    elsif user.confirmed
      notification = "🏈 We're so close, #{user.first_name}. Tap to find out how you can win an autographed football from the Super Bowl MVP!"
      content = "Get all 6 questions right for the Super Bowl contest and you'll have a chance at winning a Super Bowl MVP Autographed Football!"
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
    else
      notification = "🏈 We're so close, #{user.first_name}. Tap to find out how you can win an autographed football from the Super Bowl MVP!"
      content = "Get all 6 questions right for the Super Bowl contest and you'll have a chance at winning a Super Bowl MVP Autographed Football! Sign up below 👇"
      FacebookMessaging::Standard.deliver(
        user: user, 
        message: notification, 
        notification_type: "SILENT_PUSH"
      )
      FacebookMessaging::Button.deliver(
        user: user,
        title: "Let's go!",
        message: content,
        url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
        notification_type: "NO_PUSH"
      )
    end
  rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
    
  end
end