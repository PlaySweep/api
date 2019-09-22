namespace :prod do

  desc "Notify Active User"
  task :notify => :environment do
    users = User.active
    users.each_with_index do |user, index|
      
      begin
        if !user.confirmed || user.current_team.nil?
          content = "Week 3 Kickoff is less than 24 hours away! Type play now for more contests and prizes."
          FacebookMessaging::Standard.deliver(user, content, "SILENT_PUSH")
        elsif user.confirmed && user.current_team.present?
          content = "Week 3 Kickoff starts tomorrow! Time to get your answers in and win some prizes!"
          FacebookMessaging::Standard.deliver(user, content)
          FacebookMessaging::Carousel.deliver_team(user)
        elsif user.confirmed
          content = "Week 3 Kickoff starts tomorrow! Type play now for more contests and prizes."
          FacebookMessaging::Standard.deliver(user, content)
        end
        sleep 15 if index % 750 == 0
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