module FacebookParser
  class ButtonObject
    attr_accessor :payload

    def initialize payload
      @payload = {
        recipient: {
          id: payload[:facebook_uuid]
        },
        message: {
          attachment: {
            type: :template,
            payload: {
              template_type: :button,
              text: payload[:message],
              buttons: [
                {
                  type: :web_url,
                  url: payload[:url],
                  title: payload[:title],
                  webview_share_button: :hide,
                  webview_height_ratio: :full,
                  messenger_extensions: true
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