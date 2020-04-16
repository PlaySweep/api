require 'facebook/messenger'

module FacebookMessaging
  class MediaAttachment
    include Facebook::Messenger

    def self.deliver user:, attachment_id:, buttons: nil, quick_replies: nil, notification_type: "NO_PUSH"
      begin
        template = FacebookParser::MediaObject.new({
          facebook_uuid: user.facebook_uuid,
          attachment_id: attachment_id,
          notification_type: notification_type
        }).payload
        template[:message][:quick_replies] = quick_replies if quick_replies
        template[:message][:attachment][:payload][:elements][0][:buttons] = buttons if buttons
        Bot.deliver(template, access_token: ENV["ACCESS_TOKEN"])
      rescue Facebook::Messenger::FacebookError => e
        puts "Deactivating #{user.id}..."
        user.update_attributes(active: false)    
        puts "* User DEACTIVATED: #{user.full_name} *"    
      end 
    end
  
  end
end