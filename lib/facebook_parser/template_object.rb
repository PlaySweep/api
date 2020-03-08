module FacebookParser
  class TemplateObject
    attr_accessor :payload

    def initialize payload
      buttons = payload[:buttons].map { |button| { type: :web_url, url: button[:url], title: button[:title], messenger_extensions: true, webview_share_button: :hide, webview_height_ratio: :full } }
      @payload = {
        recipient: {
          id: payload[:facebook_uuid]
        },
        message: {
          attachment: {
            type: :template,
            payload: {
              template_type: :generic,
              elements: [
                 {
                  title: payload[:title],
                  image_url: payload[:image_url],
                  subtitle: payload[:subtitle],
                  buttons: buttons      
                }
              ]
            }
          }
        },
        message_type: "MESSAGE_TAG",
        tag: "CONFIRMED_EVENT_UPDATE",
        notification_type: payload[:notification_type]
      }
    end
  end
end