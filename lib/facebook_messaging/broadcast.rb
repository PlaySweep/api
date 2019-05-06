require 'facebook/messenger'

module FacebookMessaging
  class Broadcast
    def deliver_for resource_type:, resource_id:, message_id: 
      begin
        resource = resource_type.capitalize.constantize.find_by(id: resource_id)
        message = Message.find_by(id: message_id)
        label_id = resource.targets.find_by(name: "#{resource.class.name} #{resource.id}").label_id
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        params = { message_creative_id: message.creative_id, custom_label_id: label_id, notification_type: message.notification_type.upcase }
        response = conn.post("broadcast_messages?access_token=#{ENV["ACCESS_TOKEN"]}", params)
        broadcast_id = JSON.parse(response.body)["broadcast_id"]
        broadcast_id ? message.update_attributes(broadcast_id: broadcast_id) : message.update_attributes(failed_at: DateTime.current)
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def self.create_message resource:, content:, notification_type: "regular", schedule_time: DateTime.current, buttons: ["Play now"]
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        body = buttons ? [{text: content, quick_replies: buttons.map { |title| { content_type: "text", title: title, payload: "#{title.upcase}" } }}].to_json : [{text: content}].to_json
        response = conn.post("message_creatives?access_token=#{ENV["ACCESS_TOKEN"]}", { messages: body })
        creative_id = JSON.parse(response.body)["message_creative_id"]
        if creative_id
          resource.messages.create(body: content, owner_id: resource.id, creative_id: creative_id, schedule_time: schedule_time, category: "broadcast", notification_type: notification_type)
        else
          response.body.inspect
        end
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def self.create_target_for resource:, category: "Global"
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        name = "#{resource.class.name} #{resource.id}"
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
          label_id = resource.targets.find_by(name: "#{resource.class.name} #{resource.id}").label_id
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
        if user.roles.find_by(resource_type: "Team")
          resource = user.roles.find_by(resource_type: "Team").resource
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