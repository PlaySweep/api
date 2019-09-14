require 'facebook/messenger'

module FacebookMessaging
  module Generic
    class Contest
      include Facebook::Messenger
      def self.deliver user:, button_title: "Play now", url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1", quick_replies: nil, notification_type: "REGULAR"
        begin
          contest_copy = user.account.copies.where(category: "Contest Subtitle").sample.message
          interpolated_contest_copy = contest_copy % { team_abbreviation: team.abbreviation }
          template = Facebook::TemplateObject.new({
            facebook_uuid: user.facebook_uuid,
            title: "#{user.current_team.abbreviation.possessive} Contests",
            image_url: user.current_team.entry_image,
            subtitle: interpolated_contest_copy,
            url: url,
            button_title: button_title,
            notification_type: notification_type
          }).payload
          template[:message][:quick_replies] = quick_replies if quick_replies
          Bot.deliver(template, access_token: ENV["ACCESS_TOKEN"])
        rescue Facebook::Messenger::FacebookError => e
          puts "Facebook Messenger Error message\n\t#{e.inspect}"
          puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
        end
      end
    end

    class GlobalContest
      include Facebook::Messenger
      def self.deliver user:, button_title: "Play now", url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1", quick_replies: nil, notification_type: "REGULAR"
        begin
          contest_copy = user.account.copies.where(category: "Global Contest Subtitle").sample.message
          interpolated_contest_copy = contest_copy
          template = Facebook::TemplateObject.new({
            facebook_uuid: user.facebook_uuid,
            title: "#{user.account.friendly_name} Featured Game",
            image_url: user.account.images.find_by(category: "Account Lockup").url, # Make selections for the #{user.account.friendly_name.capitalize} Featured Game and win awesome prizes!
            subtitle: interpolated_contest_copy,
            url: url,
            button_title: button_title,
            notification_type: notification_type
          }).payload
          template[:message][:quick_replies] = quick_replies if quick_replies
          Bot.deliver(template, access_token: ENV["ACCESS_TOKEN"])
        rescue Facebook::Messenger::FacebookError => e
          puts "Facebook Messenger Error message\n\t#{e.inspect}"
          puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
        end
      end
    end
  end
end