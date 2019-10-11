namespace :prod do

  desc "Notify Active User"
  task :notify => :environment do
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
    users.each_with_index do |user, index|
      begin
        if !user.confirmed || user.current_team.nil?
          FacebookMessaging::Standard.deliver(
            user: user, 
            message: content, 
            notification_type: "REGULAR"
          )
          FacebookMessaging::Button.deliver(
            user: user,
            title: "Confirm account",
            message: "Just tap below to finish up a few quick details and get started winning prizes 👇",
            url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
            notification_type: "NO_PUSH"
          )
        elsif user.confirmed && user.current_team.present?
          FacebookMessaging::Standard.deliver(
            user: user, 
            message: content, 
            notification_type: "REGULAR"
          )
          FacebookMessaging::Generic::Contest.deliver(user: user, quick_replies: quick_replies)
        end
        sleep 10 if index % 500 == 0
      rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
        # user.update_attributes(active: false)
      end
    end
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
        content = "Week 4 Kickoff for the Eagles starts tonight! Time to get your answers in and win some prizes!"
        FacebookMessaging::Standard.deliver(user, content)
        FacebookMessaging::Carousel.deliver_team(user)
      elsif !user.confirmed
        content = "Week 4 Kickoff for the Eagles starts tonight! Type play now for more contests and prizes."
        FacebookMessaging::Standard.deliver(user, content)
      end
      sleep 15 if index % 750 == 0
    rescue Net::ReadTimeout, Facebook::Messenger::FacebookError => e
      # user.update_attributes(active: false)
    end
  end
end