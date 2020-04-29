namespace :prod do

  desc "Notify Active User"
  task :reminders => :environment do
    
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

def fetch_ids time_zone:
  Team.active.where('time_zone ilike ?', "%#{time_zone}%").sample(3).pluck(:id)
end

def send_reminder_notifications_for id:
  team = Team.find(id)
  message = team.messages.where(category: "reminders").unused.sample
  users = User.active.confirmed.joins(:roles).where('roles.resource_id = ?', id)
  users.each { |user| reminder_notification(user: user, message: message, team: team) }
end

def reminder_notification user:, message:, team:
  begin
    interpolated_message = message.body % { first_name: user.first_name, team_abbreviation: team.abbreviation }
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: interpolated_message, 
      notification_type: "REGULAR"
    )
    quick_replies = FacebookParser::QuickReplyObject.new([
      {
        content_type: :text,
        title: "Share",
        payload: "SHARE"
      }
    ]).objects
    FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
    user.notifications.create(message_id: message.id) 
  rescue Facebook::Messenger::FacebookError => e
    user.update_attributes(active: false)    
    puts "* User DEACTIVATED: #{user.full_name} *"
  end
end

def global_announcement user:
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
end

def send_engagement_notification
  account = Account.find_by(name: "MLB")
  message = account.messages.where(category: "engagement").unused.sample
  users = User.active.where(confirmed: false).sample(2500)
  users.each { |user| re_engagement_notification(user: user, message: message) }
end

def re_engagement_notification user:, message:
  begin
    content = "Finish your account setup below and start winning Budweiser, MLB, and team swag #{user.first_name} 🍻!"
    FacebookMessaging::Standard.deliver(
      user: user, 
      message: message.body, 
      notification_type: "SILENT_PUSH"
    )
    FacebookMessaging::Button.deliver(
      user: user,
      title: "Confirm your account",
      message: content,
      url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
      notification_type: "NO_PUSH"
    )
    user.notifications.create(message_id: message.id)
  rescue Facebook::Messenger::FacebookError => e
    user.update_attributes(active: false)    
    puts "* User DEACTIVATED: #{user.full_name} *"
  end
end

