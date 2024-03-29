require 'facebook/messenger'

module FacebookMessaging
  class ImageAttachment
    include Facebook::Messenger

    def self.deliver user:, image_url:, quick_replies: nil, notification_type: "NO_PUSH"
      begin
        template = FacebookParser::ImageObject.new({
          facebook_uuid: user.facebook_uuid,
          image_url: image_url,
          notification_type: notification_type
        }).payload
        template[:message][:quick_replies] = quick_replies if quick_replies
        Bot.deliver(template, access_token: ENV["ACCESS_TOKEN"])
      rescue Facebook::Messenger::FacebookError => e
        puts "error => #{e.inspect}"     
      end
      
    end
  
  end
end
