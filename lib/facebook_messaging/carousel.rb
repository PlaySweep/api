require 'facebook/messenger'

module FacebookMessaging
  class Carousel
    include Facebook::Messenger

    def self.deliver_bud user, url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load", quick_replies=nil
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
            image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/cleveland_browns_fb_logo.png",
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
            title: "#{team.abbreviation} Leaderboard",
            image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/bud_light_leaderboard_logo2.png",
            subtitle: "See how you rank against the competition!",
            buttons: [
              {
                type: :web_url,
                url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=2",
                title: "Leaderboard",
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

    def self.deliver_both user, url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load", quick_replies=nil
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
          title: "Road to All-Star",
          image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/allstar_prizing_image.png",
          subtitle: "Play the Road to All-Star for a chance to win tickets to the game and more!",
          buttons: [
            {
              type: :web_url,
              url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=2",
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
                    title: "Road to All-Star",
                    image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/allstar_prizing_image.png",
                    subtitle: "Play the Road to All-Star for a chance to win tickets to the game and more!",
                    buttons: [
                      {
                        type: :web_url,
                        url: "#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load?tab=2",
                        title: "Play now",
                        webview_height_ratio: 'full',
                        messenger_extensions: true
                      }
                    ]
                  },
                    {
                    title: "Road to All-Star Leaderboard",
                    image_url: "https://s3.amazonaws.com/budweiser-sweep-assets/allstar_fb_logo.png",
                    subtitle: "See how you rank against the competition!",
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
                    title: "Road to All-Star Prizing",
                    image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/allstar_prizing_logo.png",
                    subtitle: "There are tons of prizes on the line for the Road to All-Star!",
                    buttons: [
                      {
                        type: :web_url,
                        url: "#{ENV["WEBVIEW_URL"]}/prizing/allstar",
                        title: "Prizes",
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

    def self.deliver_global user, url="#{ENV["WEBVIEW_URL"]}/#{user.facebook_uuid}/dashboard/initial_load", quick_replies=nil
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
                  title: "Road to All-Star Leaderboard",
                  image_url: "https://s3.amazonaws.com/budweiser-sweep-assets/allstar_fb_logo.png",
                  subtitle: "See how you rank against the competition!",
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
                title: "Road to All-Star Prizes",
                image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/allstar_prizing_logo.png",
                subtitle: "There are tons of prizes on the line for the Road to All-Star!",
                buttons: [
                  {
                    type: :web_url,
                    url: "#{ENV["WEBVIEW_URL"]}/prizing/allstar",
                    title: "Prizes",
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