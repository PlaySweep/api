require 'facebook/messenger'
require 'net/http'
require 'uri'
require 'json'

module FacebookMessaging
  class Broadcast
    def deliver_for resource: 
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v3.3/me/")
        message = Message.find_by(messageable_type: "Owner", messageable_id: resource.id, used: false, failed_at: nil)
        label_id = resource.targets.find_by(name: "#{resource.class.name} #{resource.id}").label_id
        params = { message_creative_id: message.creative_id, custom_label_id: label_id, notification_type: message.notification_type.upcase }
        response = conn.post("broadcast_messages?access_token=#{ENV["ACCESS_TOKEN"]}", params)
        broadcast_id = JSON.parse(response.body)["broadcast_id"]
        broadcast_id ? message.update_attributes(broadcast_id: broadcast_id, used: true) : message.update_attributes(failed_at: DateTime.current)
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def deliver message_creative_id
     conn = Faraday.new(:url => "https://graph.facebook.com/v3.3/me/")
     params = { message_creative_id: message_creative_id, notification_type: "REGULAR", messaging_type: "MESSAGE_TAG", tag: "NON_PROMOTIONAL_SUBSCRIPTION" }
     response = conn.post("broadcast_messages?access_token=#{ENV["ACCESS_TOKEN"]}", params)
     broadcast_id = JSON.parse(response.body)["broadcast_id"]
     if broadcast_id
      puts "Success"
     else
      puts "Failed"
      puts response.inspect
     end
    end

    def self.create_message resource:, content:, notification_type: "regular", schedule_time: DateTime.current, buttons: ["Play now"]
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        body = buttons ? [{text: content, quick_replies: buttons.map { |title| { content_type: "text", title: title, payload: "#{title.upcase}" } }}].to_json : [{text: content}].to_json
        response = conn.post("message_creatives?access_token=#{ENV["ACCESS_TOKEN"]}", { messages: body })
        creative_id = JSON.parse(response.body)["message_creative_id"]
        if creative_id
          resource.messages.create(body: content, creative_id: creative_id, schedule_time: schedule_time, category: "broadcast", notification_type: notification_type)
        else
          response.body.inspect
        end
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def create_media_message attachment_id

      uri = URI.parse("https://graph.facebook.com/v3.3/me/message_creatives?access_token=#{ENV["ACCESS_TOKEN"]}")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request.body = JSON.dump({
        "messages" => [
          {
            "attachment" => {
              "type" => "template",
              "payload" => {
                "template_type" => "media",
                "elements" => [
                  {
                    "media_type" => "image",
                    "attachment_id" => attachment_id,
                  }
                ]
              }
            }
          }
        ]
      })

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        data = http.request(request)
      end
      if response.code == 200
        body = JSON.parse(response.body)
        body.message_creative_id
      end
    end

    def self.create_target_for resource:, category: "Global"
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        name = "#{category} #{resource.id}"
        params = { name: name }
        response = conn.post("custom_labels?access_token=#{ENV["ACCESS_TOKEN"]}", params)
        label_id = JSON.parse(response.body)["id"]
        resource.targets.create(name: name, label_id: label_id, category: category)
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def self.subscribe resource:, user:
      begin
        if user.roles.find_by(resource_type: resource.class.name)
          label_id = resource.targets.find_by(category: "Team").label_id
          conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/#{label_id}")
          params = { user: user.facebook_uuid }
          response = conn.post("label?access_token=#{ENV["ACCESS_TOKEN"]}", params)
          success = JSON.parse(response.body)["success"]
          if success == true
            puts "Successfully subscribed user with Broadcast Label 👍"
          else
            puts "⁉️"
          end
        end
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect} for #{user.facebook_uuid}"
      end
    end

    def self.unsubscribe user:
      begin
        role = user.roles.find_by(resource_type: "Team")
        if role
          resource = role.resource
          label_id = resource.targets.find_by(name: "#{resource.class.name} #{resource.id}").label_id
          conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/#{label_id}")
          params = { user: user.facebook_uuid }
          response = conn.delete("label?user=#{user.facebook_uuid}&access_token=#{ENV["ACCESS_TOKEN"]}", params)
          success = JSON.parse(response.body)["success"]
          if success == true
            puts "Successfully unsubscribed user with Broadcast Label 👍"
          else
            puts "⁉️"
          end
        end
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
        puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
      end
    end

    def self.fetch_all_labels
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        response = conn.get("custom_labels?fields=name&access_token=#{ENV["ACCESS_TOKEN"]}")
        data = JSON.parse(response.body)["data"]
        puts data
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def self.cancel broadcast_id:
      conn = Faraday.new(:url => "https://graph.facebook.com/v3.3/me/")
      params = { operation: "cancel" }
      response = conn.post("#{broadcast_id}?access_token=#{ENV["ACCESS_TOKEN"]}", params)
      success = JSON.parse(response.body)["success"]
      if success == true
        puts "Successfully deleted Broadcast Label 👍"
      else
        puts "⁉️"
      end
    end

    def self.destroy label_id:
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/#{label_id}")
        response = conn.delete("?access_token=#{ENV["ACCESS_TOKEN"]}")
        success = JSON.parse(response.body)["success"]
        if success == true
          puts "Successfully deleted Broadcast Label 👍"
        else
          puts "⁉️"
        end
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

  end
end