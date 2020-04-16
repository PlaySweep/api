require 'facebook/messenger'

module FacebookMessaging
  class Standard
    include Facebook::Messenger

    def self.deliver user:, message:, notification_type: "REGULAR", quick_replies: nil
      begin
        template = FacebookParser::StandardObject.new({
          facebook_uuid: user.facebook_uuid,
          message: message,
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