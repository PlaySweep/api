module FacebookParser
  class TemplateObject
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
              template_type: :generic,
              elements: [
                 {
                  title: payload[:title],
                  image_url: payload[:image_url],
                  subtitle: payload[:subtitle],
                  buttons: [
                    {
                      type: :web_url,
                      url: payload[:url],
                      title: payload[:button_title],
                      messenger_extensions: true,
                      webview_height_ratio: :full
                    }              
                  ]      
                }
              ]
            }
          }
        },
        message_type: "UPDATE",
        notification_type: payload[:notification_type]
      }
    end
  end
end