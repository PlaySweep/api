require 'facebook/messenger'
load 'lib/facebook_messaging/base.rb'

module FacebookMessaging
  class QuickReply < Base
    include Facebook::Messenger

    def self.deliver user, message, quick_replies, notification_type="REGULAR"
      begin
        Bot.deliver({
          recipient: {
            id: user.facebook_uuid
          },
          message: {
            text: message,
            quick_replies: quick_replies
          },
          message_type: "UPDATE",
          notification_type: notification_type
        }, access_token: credentials.send(Apartment::Tenant.current).try(:access_token)))
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
        puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
      end
    end
  end
end