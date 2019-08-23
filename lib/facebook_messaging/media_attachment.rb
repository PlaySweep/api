require 'facebook/messenger'

module FacebookMessaging
  class MediaAttachment
    include Facebook::Messenger

    def self.deliver user, attachment_id, quick_replies=nil
      begin
        @template = {
          recipient: {
            id: user.facebook_uuid
          },
          message: {
            attachment: {
              type: 'template',
              payload: {
                template_type: "media",
                elements: [
                  media_type: "image",
                  attachment_id: attachment_id
                ]
              }
            }
          },
          message_type: "UPDATE",
          notification_type: "NO_PUSH"
        }

        if quick_replies && quick_replies.any?
          @template[:message][:quick_replies] = quick_replies
        end

        Bot.deliver(@template, access_token: ENV["ACCESS_TOKEN"])
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
        puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
      end
      
    end

    def self.deliver_with_button user, attachment_id, quick_replies=nil
      begin
        @template = {
          recipient: {
            id: user.facebook_uuid
          },
          message: {
            attachment: {
              type: 'template',
              payload: {
                template_type: "media",
                elements: [
                  media_type: "image",
                  attachment_id: attachment_id,
                  buttons: [
                    {
                      type: :web_url,
                      url: "#{ENV["WEBVIEW_URL"]}/confirmation/#{user.slug}",
                      title: "Confirm your account",
                      webview_height_ratio: 'full',
                      messenger_extensions: true
                    }
                  ]
                ]
              }
            }
          },
          message_type: "UPDATE",
          notification_type: "NO_PUSH"
        }

        if quick_replies && quick_replies.any?
          @template[:message][:quick_replies] = quick_replies
        end

        Bot.deliver(@template, access_token: ENV["ACCESS_TOKEN"])
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
        puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
      end
      
    end
  
  end
end