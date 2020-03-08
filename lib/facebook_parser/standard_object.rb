module FacebookParser
  class StandardObject
    attr_accessor :payload

    def initialize payload
      @payload = {
        recipient: {
          id: payload[:facebook_uuid]
        },
        message: {
          text: payload[:message]
        },
        message_type: "MESSAGE_TAG",
        tag: "CONFIRMED_EVENT_UPDATE",
        notification_type: payload[:notification_type]
      }
    end
  end
end