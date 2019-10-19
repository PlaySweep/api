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
        content = "Week 7 kicks off tonight at Mile High! Get your answers in for your chance at a Broncos autographed football!"
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
        content = "Week 7 kicks off at Mile High with tonight's contest!"
        FacebookMessaging::Standard.deliver(
          user: user, 
          message: content, 
          notification_type: "REGULAR"
        )
        FacebookMessaging::Button.deliver(
            user: user,
            title: "Confirm account",
            message: "You're a few steps away at a chance at winning a Broncos autographed football!",
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