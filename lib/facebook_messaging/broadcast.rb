module FacebookMessaging
  class Broadcast
    def self.deliver
      DeliverBroadcastJob.perform_later
    end

    def self.create_broadcast_message
      conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
      Team.first(3).each do |team|
        quick_replies = [{ content_type: 'text', title: "PLAY NOW ⚾️", payload: "More contests" }]
        body = [{text: "Opening Day. It's officially time for real, regular season action. We've got #{team.name} contests and prizes for you!", quick_replies: quick_replies}].to_json
        params = { messages: body }

        response = conn.post("message_creatives?access_token=#{ENV['ACCESS_TOKEN']}", params)
        message_creative_id = JSON.parse(response.body)["message_creative_id"]
        team.update_attributes(broadcast_message_id: message_creative_id)
      end
    end

    def self.generate_broadcast_label_for resource:
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        params = { name: "#{resource.class.name} #{resource.id}" }
        response = conn.post("custom_labels?access_token=#{ENV['ACCESS_TOKEN']}", params)
        label_id = JSON.parse(response.body)["id"]
        resource.update_attributes(broadcast_label_id: label_id)
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def self.subscribe_broadcast user
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/#{user.preference.team.broadcast_label_id}/")
        params = { user: user.facebook_uuid }
        response = conn.post("label?access_token=#{ENV['ACCESS_TOKEN']}", params)
        success = JSON.parse(response.body)["success"]
        if success == true
          puts "Successfully subscribed user with Broadcast Label 👍"
        else
          puts "⁉️"
        end
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
        puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"
      end
    end

    def self.unsubscribe_broadcast user
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/#{user.preference.team.broadcast_label_id}/")
        params = { user: user.facebook_uuid }
        response = conn.delete("label?user=#{user.facebook_uuid}&access_token=#{ENV['ACCESS_TOKEN']}", params)
        success = JSON.parse(response.body)["success"]
        if success == true
          puts "Successfully unsubscribed user with Broadcast Label 👍"
        else
          puts "⁉️"
        end
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
        puts "#{user.full_name} Not found (facebook_uuid: #{user.facebook_uuid})"     
      end
    end

    def self.fetch_all_labels
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
        response = conn.get("custom_labels?fields=name&access_token=#{ENV['ACCESS_TOKEN']}")
        data = JSON.parse(response.body)["data"]
        puts data
      rescue Facebook::Messenger::FacebookError => e
        puts "Facebook Messenger Error message\n\t#{e.inspect}"
      end
    end

    def self.destroy label_id
      begin
        conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/#{label_id}")
        response = conn.delete("?access_token=#{ENV['ACCESS_TOKEN']}")
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