require 'facebook/messenger'

module FacebookMessaging
  class Button
    include Facebook::Messenger

    def self.deliver user:, title:, message:, url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}", quick_replies: nil, notification_type: "NO_PUSH"
      begin
        template = FacebookParser::ButtonObject.new({
          facebook_uuid: user.facebook_uuid,
          message: message,
          url: url,
          title: title,
          notification_type: notification_type
        }).payload
        template[:message][:quick_replies] = quick_replies if quick_replies
        Bot.deliver(template, access_token: ENV["ACCESS_TOKEN"])
      rescue Facebook::Messenger::FacebookError => e
        puts "Deactivating #{user.id}..."
        user.update_attributes(active: false)    
        puts "* User DEACTIVATED: #{user.full_name} *"   
      end
    end
  end
end