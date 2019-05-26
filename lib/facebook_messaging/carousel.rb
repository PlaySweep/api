require 'facebook/messenger'

module FacebookMessaging
  class Carousel
    include Facebook::Messenger

    def self.deliver_team user, url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load", quick_replies=nil
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
                    title: "Status",
                    subtitle: "Check your status or make changes to your selections.",
                    default_action: {
                      type: "web_url",
                      url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=3",
                      webview_height_ratio: "full",
                    },
                    buttons: [
                      {
                        type: :web_url,
                        url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=3",
                        title: "Status",
                        webview_height_ratio: 'full',
                        messenger_extensions: true
                      }
                    ]
                  },
                  {
                  title: "Invite friends",
                  subtitle: "Earn entries into our daily prize drawings when your friends join!",
                  buttons: [
                    {
                      type: :postback,
                      title: "Invite friends",
                      payload: "INVITE FRIENDS"
                    }
                  ]
                }
              ]
            }
          }
        },
          message_type: "UPDATE",
          notification_type: "SILENT_PUSH"
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

    def self.deliver_global user, url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load", quick_replies=nil
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
                  title: "Leaderboard",
                  subtitle: "See how you rank against the competition!",
                  default_action: {
                    type: "web_url",
                    url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/leaderboard/allstar",
                    webview_height_ratio: "full",
                  },
                  buttons: [
                    {
                      type: :web_url,
                      url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/leaderboard/allstar",
                      title: "Leaderboard",
                      webview_height_ratio: 'full',
                      messenger_extensions: true
                    }
                  ]
                },
                  {
                  title: "Contests",
                  subtitle: "Make your selections and win prizes!",
                  default_action: {
                    type: "web_url",
                    url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load",
                    webview_height_ratio: "full",
                  },
                  buttons: [
                    {
                      type: :web_url,
                      url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load",
                      title: "Play now",
                      webview_height_ratio: 'full',
                      messenger_extensions: true
                    }
                  ]
                },
                  {
                  title: "Status",
                  subtitle: "Check your status or make changes to your selections.",
                  default_action: {
                    type: "web_url",
                    url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=3",
                    webview_height_ratio: "full",
                  },
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
          notification_type: "SILENT_PUSH"
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