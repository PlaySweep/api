require 'facebook/messenger'

module FacebookMessaging
  module Generic
    class Contest
      include Facebook::Messenger
      def self.deliver user:, quick_replies: nil, notification_type: "NO_PUSH"
        begin
          contest_copy = user.account.copies.where(category: "Contest Subtitle").sample.message
          interpolated_contest_copy = contest_copy % { team_abbreviation: user.current_team.abbreviation }
          template = FacebookParser::TemplateObject.new({
            facebook_uuid: user.facebook_uuid,
            title: "#{user.current_team.abbreviation.possessive} Contests",
            image_url: user.current_team.entry_image,
            subtitle: interpolated_contest_copy,
            buttons: [{title: "More contests", url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}"}],
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
      def self.deliver user:, quick_replies: nil, notification_type: "NO_PUSH"
        begin
          contest_copy = user.account.copies.where(category: "Global Contest Subtitle").sample.message
          interpolated_contest_copy = contest_copy
          template = FacebookParser::TemplateObject.new({
            facebook_uuid: user.facebook_uuid,
            title: "#{user.account.friendly_name} Featured Game",
            image_url: user.account.images.find_by(category: "Account Lockup").url, # Make selections for the #{user.account.friendly_name.capitalize} Featured Game and win awesome prizes!
            subtitle: interpolated_contest_copy,
            buttons: [{title: "More contests", url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}"}, {title: "See status", url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/2"}],
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

    class Promotion
      include Facebook::Messenger
      def self.deliver user:, quick_replies: nil, notification_type: "NO_PUSH"
        begin
          template = FacebookParser::TemplateObject.new({
            facebook_uuid: user.facebook_uuid,
            title: "$20 Drizly Credit",
            image_url: user.account.images.find_by(category: "Drizly Lockup").url,
            subtitle: "🍺 Celebrate your victory with a #{user.account.friendly_name}!",
            buttons: [{title: "Claim now", url: "https://budlightsweeps.typeform.com/to/r6SOAJ"}],
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

    class Web
      include Facebook::Messenger
      def self.deliver user:, quick_replies: nil, notification_type: "NO_PUSH"
        begin
          template = FacebookParser::TemplateObject.new({
            facebook_uuid: user.facebook_uuid,
            title: "Order your #{user.account.friendly_name}!",
            image_url: user.account.images.find_by(category: "Drizly Lockup").url,
            buttons: [{title: "🍺 Order now", url: "https://drizly.com/beer-brands/bud-light/b1019?utm_medium=partner&utm_source=email&utm_campaign=budlight+sports+sweep+winner+email"}],
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