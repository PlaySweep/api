require 'facebook/messenger'
json_data = YAML::load_file("#{Rails.root}/config/application.yml").to_json
$credentials = JSON.parse(json_data, object_class: OpenStruct)

module FacebookMessaging
  class TextButton
    include Facebook::Messenger

    def self.deliver user, title, message, notification_type="REGULAR", url="#{$credentials.send(Apartment::Tenant.current).webview_url}/#{user.facebook_uuid}/dashboard/initial_load"
      begin
        Bot.deliver({
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
            }
          },
          message_type: "UPDATE",
          notification_type: notification_type
        }, access_token: $credentials.send(Apartment::Tenant.current).access_token)
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
        puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
      end
    end
  end
end