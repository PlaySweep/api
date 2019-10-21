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

def notify users:
  users.each_with_index do |user, index|
    begin
      if user.confirmed && user.current_team.present?
        content = "We're only a few hours away from #{user.current_team.abbreviation} Week 7 kickoff! Answer 6 questions today and win!"
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
        content = "We're only a few hours away from Week 7 kickoff! Answer 6 questions today and win!"
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
      sleep 30 if index % 250 == 0
    rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
      # user.update_attributes(active: false)
    end
  end
end