module FacebookParser
  class ImageObject
    attr_accessor :payload

    def initialize payload
      @payload = {
        recipient: {
          id: payload[:facebook_uuid]
        },
        message: {
          attachment: {
            type: :image,
            payload: {
              url: payload[:image_url]
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