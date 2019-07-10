require 'facebook/messenger'

module FacebookMessaging
  class Carousel
    include Facebook::Messenger

    def self.deliver_team user, url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load", quick_replies=nil
      team = user.roles.find_by(resource_type: "Team").resource
      begin
        @template = {
          recipient: {
            id: user.facebook_uuid
          },
          message: {
            attachment: {
              type: 'template',
              payload: {
                template_type: 'generic',
                elements: [
          {
          title: "#{team.abbreviation} Contests",
          image_url: team.local_image,
          subtitle: "Make selections for your #{team.name} every day and win awesome prizes!",
          buttons: [
            {
              type: :web_url,
              url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=1",
              title: "Play now",
              webview_height_ratio: 'full',
              messenger_extensions: true
            }
          ]
        },
        {
          title: "Status",
          image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/fb_status_logo2.png",
          subtitle: "Check your results or make any changes before the games start!",
          buttons: [
            {
              type: :web_url,
              url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=3",
              title: "Status",
              webview_height_ratio: 'full',
              messenger_extensions: true
            }
          ]
        }
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