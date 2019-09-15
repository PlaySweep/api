module FacebookParser
  class QuickReplyObject
    attr_accessor :object

    def initialize object
      @object = {
        content_type: :text,
        title: object[:title],
        payload: object[:payload]
      }
      @object[:image_url] = object[:image_url] if object[:image_url]
    end
  end

  class QuickReplyLocationObject
    attr_accessor :object

    def initialize object
      @object = {
        content_type: :location
      }
      @object[:image_url] = object[:image_url] if object[:image_url]
    end
  end

  class QuickReplyPhoneNumberObject
    attr_accessor :object

    def initialize object
      @object = {
        content_type: :user_phone_number
      }
      @object[:image_url] = object[:image_url] if object[:image_url]
    end
  end
end