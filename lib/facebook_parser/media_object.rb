module FacebookParser
  class MediaObject
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
              template_type: :media,
              elements: [
                media_type: :image,
                attachment_id: payload[:attachment_id]
              ]
            }
          }
        },
        message_type: "RESPONSE",
        notification_type: payload[:notification_type]
      }
    end
  end
end