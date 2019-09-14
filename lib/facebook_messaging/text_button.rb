require 'facebook/messenger'
Card.deliver(user: user, title: "Falcons' Contests", image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/atlanta_falcons_fb_lockup.png", subtitle: "Play Falcons' Contests now!", quick_replies: quick_replies)

module FacebookMessaging
  class TextButton
    include Facebook::Messenger

    def self.deliver user, title, message, notification_type="REGULAR", url="#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1", quick_replies=nil
      begin
        @template = {
          recipient: {
            id: user.facebook_uuid
          },
          message: {
            attachment: {
              type: 'template',
              payload: {
                template_type: 'button',
                text: message,
                buttons: [
                  {
                    type: :web_url,
                    url: url,
                    title: title,
                    webview_height_ratio: 'full',
                    messenger_extensions: true
                  }
                ]
              }
            },
            quick_replies: quick_replies
          },
          message_type: "UPDATE",
          notification_type: notification_type
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