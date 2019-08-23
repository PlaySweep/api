require 'facebook/messenger'

module FacebookMessaging
  class Carousel
    include Facebook::Messenger

    def self.deliver_drizly user, price, url="https://drizly.com", quick_replies=nil
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
                  title: "$#{price} Drizly Credit",
                  image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/bud_light_drizly_lockup.png",
                  subtitle: "Redeem your $#{price} Drizly credit below 👇",
                  buttons: [
                    {
                      type: :web_url,
                      url: url,
                      title: "Redeem now",
                      webview_height_ratio: 'full',
                      messenger_extensions: true
                    }
                  ]
                },
                {
                title: "#{team.abbreviation.possessive} Contests",
                image_url: team.entry_image,
                subtitle: "Make selections for your #{team.name} every week and win awesome prizes!",
                buttons: [
                  {
                    type: :web_url,
                    url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1",
                    title: "Play now",
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

    def self.deliver_team user, url="#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1", quick_replies=nil
      team = user.roles.find_by(resource_type: "Team").try(:resource)
      begin
        if team
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
                  url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1",
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
                  url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/2",
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
        else
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
                title: "#{user.account.friendly_name.capitalize} Game of the Day",
                image_url: user.account.images.find_by(category: "Account Lockup").url,
                subtitle: "Make selections for the #{user.account.friendly_name.capitalize} Game of the Day and win awesome prizes!",
                buttons: [
                  {
                    type: :web_url,
                    url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/1",
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
                  url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{user.slug}/2",
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
        end

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